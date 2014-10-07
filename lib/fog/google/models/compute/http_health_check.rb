require 'fog/core/model'

module Fog
  module Compute
    class Google
      class HttpHealthCheck < Fog::Model
        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :self_link, :aliases => 'selfLink'
        attribute :id, :aliases => 'id'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description, :aliases => 'description'
        attribute :host, :aliases => 'host'
        attribute :request_path, :aliases => 'requestPath'
        attribute :port, :aliases => 'port'
        attribute :check_interval_sec, :aliases => 'checkIntervalSec'
        attribute :timeout_sec, :aliases => 'timeoutSec'
        attribute :unhealthy_threshold, :aliases => 'unhealthyThreshold'
        attribute :healthy_threshold, :aliases => 'healthyThreshold'

        def save
          requires :name

          options = {
            'description' => description,
            'host' => host,
            'requestPath' => request_path || "/",
            'port' => port || 80,
            'checkIntervalSec' => check_interval_sec || 5,
            'timeoutSec' => timeout_sec || 5,
            'unhealthyThreshold' => unhealthy_threshold || 2,
            'healthyThreshold' => healthy_threshold || 2,
          }

          data = service.insert_http_health_check(name, options).body
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data['name'], data['zone'])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async=true)
          requires :name
          operation = service.delete_http_health_check(name)

          if not async
            # wait until "DONE" to ensure the operation doesn't fail, raises
            # exception on error
            Fog.wait_for do
              operation = service.get_global_operation(operation.body["name"])
              operation.body["status"] == "DONE"
            end
          end
          operation
        end

        def ready?
          begin
            service.get_http_health_check(self.name)
            true
          rescue Fog::Errors::NotFound
            false
          end
        end

        def reload
          requires :name

          return unless data = begin
            collection.get(name)
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
