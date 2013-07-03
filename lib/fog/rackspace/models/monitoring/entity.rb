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

        def prep
          options = {
            'label'       => label,
            'metadata'    => metadata,
            'ip_addresses'=> ip_addresses,
            'agent_id'    => agent_id
          }
          options = options.reject {|key, value| value.nil?}
          options
        end

        def save
          options = prep
          if identity then
            data = service.update_entity(identity, options)
          else
            data = service.create_entity(options)
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
