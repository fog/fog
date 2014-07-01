require 'fog/core/model'

module Fog
  module Compute
    class Google
      class ForwardingRule < Fog::Model
        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :self_link, :aliases => 'selfLink'
        attribute :id, :aliases => 'id'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description, :aliases => 'description'
        attribute :region, :aliases => 'region'
        attribute :ip_address, :aliases => 'IPAddress'
        attribute :ip_protocol, :aliases => 'IPProtocol'
        attribute :port_range, :aliases => 'portRange'
        attribute :target, :aliases => 'target'

        def save
          requires :name, :region, :target

          options = {
            'description' => description,
            'region' => region,
            'IPAddress' => ip_address,
            'IPProtocol' => ip_protocol || "TCP",
            'portRange' => port_range,
            'target' => target
          }

          data = service.insert_forwarding_rule(name, region, options).body
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data['name'], nil, data['region'])
          operation.wait_for { !pending? }
          reload
        end

        def set_target new_target
          new_target = new_target.self_link unless new_target.class == String
          self.target = new_target
          service.set_forwarding_rule_target(self, new_target)
          reload
        end

        def destroy(async=true)
          requires :name, :region
          operation = service.delete_forwarding_rule(name, region)
          if not async
            # wait until "RUNNING" or "DONE" to ensure the operation doesn't
            # fail, raises exception on error
            Fog.wait_for do
              operation = service.get_region_operation(region, operation.body["name"])
              operation.body["status"] == "DONE"
            end
          end
          operation
        end

        def ready?
          begin
            service.get_forwarding_rule(self.name, self.region)
            true
          rescue Fog::Errors::NotFound
            false
          end
        end

        def reload
          requires :name, :region

          return unless data = begin
            collection.get(name, region)
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
