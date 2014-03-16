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
            'requestPath' => request_path,
            'port' => port,
            'checkIntervalSec' => check_interval_sec,
            'timeoutSec' => timeout_sec,
            'unhealthyThreshold' => unhealthy_threshold,
            'healthyThreshold' => healthy_threshold,
          }

          service.insert_http_health_check(name, options).body
          data = service.backoff_if_unfound {service.get_http_health_check(name).body}
          service.http_health_checks.merge_attributes(data)
        end

        def destroy
          requires :name
          operation = service.delete_http_health_check(name)
          # wait until "RUNNING" or "DONE" to ensure the operation doesn't fail, raises exception on error
          Fog.wait_for do
            operation = service.get_global_operation(operation.body["name"])
            operation.body["status"] != "PENDING"
          end
          operation
        end

        def reload
          requires :identity
          requires :zone_name

          return unless data = begin
            collection.get(identity, zone_name)
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
