require 'fog/core/model'

module Fog
  module Compute
    class Google
      class GlobalForwardingRule < Fog::Model
        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :self_link, :aliases => 'selfLink'
        attribute :id, :aliases => 'id'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description, :aliases => 'description'
        attribute :region, :aliases => 'region' # should always be 'global'
        attribute :ip_address, :aliases => 'IPAddress' # string
        attribute :ip_protocol, :aliases => 'IPProtocol' # string
        attribute :port_range, :aliases => 'portRange' # string
        attribute :target, :aliases => 'target' # string, URL of global target http proxy

        def save
          requires :name
          
          options = {
            'description' => description,
            'region' => 'global',
            'IPAddress' => ip_address,
            'IPProtocol' => ip_protocol || "TCP",
            'portRange' => port_range || 80,
            'target' => target
          }

          data = service.insert_global_forwarding_rule(name,  options).body
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data['name'], nil, data['region'])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async=true)
          requires :name

          operation = service.delete_global_forwarding_rule(name, 'global')
          if not async
            # wait until "RUNNING" or "DONE" to ensure the operation doesn't
            # fail, raises exception on error
            Fog.wait_for do
              operation.body["status"] == "DONE"
            end
          end
          operation
        end

        def set_target new_target
          new_target = new_target.self_link unless new_target.class == String
          self.target = new_target
          service.set_global_forwarding_rule_target(self, new_target)
          reload
        end

        def ready?
          begin
            service.get_global_forwarding_rule(self.name, 'global')
            true
          rescue Fog::Errors::NotFound
            false
          end
        end

        def reload
          requires :name

          return unless data = begin
            collection.get(name, 'global')
          rescue Excon::Errors::SocketError
            nil
          end

          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end

        RUNNING_STATE = "READY"
      end
    end
  end
end
