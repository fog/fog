require 'fog/core/model'

module Fog
  module Compute
    class Google
      ##
      # Represents an Address resource
      #
      # @see https://developers.google.com/compute/docs/reference/latest/addresses
      class Address < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :address
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description
        attribute :region
        attribute :self_link, :aliases => 'selfLink'
        attribute :status
        attribute :users

        IN_USE_STATE   = 'IN_USE'
        RESERVED_STATE = 'RESERVED'

        def server
          return nil if !in_use? || self.users.nil? || self.users.empty?

          service.servers.get(self.users.first.split('/')[-1])
        end

        def server=(server)
          requires :identity, :region
          server ? associate(server) : disassociate
        end

        def save
          requires :identity, :region

          data = service.insert_address(identity, self.region, self.attributes)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], nil, data.body['region'])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async=true)
          requires :identity, :region

          data = service.delete_address(identity, self.region.split('/')[-1])
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], nil, data.body['region'])
          unless async
            operation.wait_for { ready? }
          end
          operation
        end

        def reload
          requires :identity, :region

          data = collection.get(identity, self.region.split('/')[-1])
          merge_attributes(data.attributes)
          self
        end

        def in_use?
          self.status == IN_USE_STATE
        end

        private

        def associate(server)
          nic = server.network_interfaces.first['name']
          data = service.add_server_access_config(server.name, server.zone_name, nic, :address => self.address)
          Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
        end

        def disassociate
          return nil if !in_use? || self.users.nil? || self.users.empty?

          # An address can only be associated with one server at a time
          server = service.servers.get(self.users.first.split('/')[-1])
          nic = server.network_interfaces.first['name']
          unless server.network_interfaces.first['accessConfigs'].nil? ||
                 server.network_interfaces.first['accessConfigs'].empty?
            access_config = server.network_interfaces.first['accessConfigs'].first['name']
            data = service.delete_server_access_config(server.name, server.zone_name, nic,
                                                       :access_config => access_config)
            Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
          end
        end
      end
    end
  end
end
