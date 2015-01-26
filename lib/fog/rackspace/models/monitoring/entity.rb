require 'fog/core/model'
require 'fog/rackspace/models/monitoring/base'

module Fog
  module Rackspace
    class Monitoring
      class Entity < Fog::Rackspace::Monitoring::Base
        identity :id

        attribute :label
        attribute :metadata
        attribute :ip_addresses
        attribute :agent_id
        attribute :managed, :default => false
        attribute :uri

        def params
          options = {
            'label'       => label,
            'metadata'    => metadata,
            'ip_addresses'=> ip_addresses,
            'agent_id'    => agent_id
          }
          options.reject {|key, value| value.nil?}
        end

        def save
          if identity
            data = service.update_entity(identity, params)
          else
            data = service.create_entity(params)
            self.id = data.headers['X-Object-ID']
          end
          true
        end

        def checks
          @checks ||= begin
            Fog::Rackspace::Monitoring::Checks.new(
              :entity     => self,
              :service => service
            )
          end
        end

        def alarms
          @alarms ||= begin
            Fog::Rackspace::Monitoring::Alarms.new(
              :entity     => self,
              :service => service
            )
          end
        end

        def destroy
          requires :id
          service.delete_entity(id)
        end
      end
    end
  end
end
