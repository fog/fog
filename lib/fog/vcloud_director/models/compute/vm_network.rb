require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector

      class VmNetwork < Model

        identity  :id

        attribute :type
        attribute :href
        attribute :info
        attribute :primary_network_connection_index
        attribute :connections

        def <<(new_connection)
          self.primary_network_connection_index = 0 if connections.empty?
          if new_connection.is_a?(Fog::Compute::VcloudDirector::Network)
            connections << convert_to_connection(new_connection)
          else
            connections << new_connection
          end
          save
        end

        def [](connection_name)
          connections.select do |connection|
            connection[:network] == connection_name
          end.first
        end

        def []=(connection_name, attributes)
          connections.delete(self[connection_name])
          connections << attributes
          save
        end

        def remove(connection_name)
          connections.delete(self[connection_name])
          save
        end

        def save
          response = service.put_network_connection_system_section_vapp(id, attributes)
          service.process_task(response.body)
        end

        private
        def convert_to_connection(network)
          connection = {}
          connection[:network] = network.name
          connection[:network_connection_index] = connections.count
          connection
        end
      end
    end
  end
end
