require 'fog/core/model'

module Fog
  module Compute
    class Google

      class TargetPool < Fog::Model

        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :self_link, :aliases => 'selfLink'
        attribute :id, :aliases => 'id'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description, :aliases => 'description'
        attribute :region, :aliases => "region"
        attribute :health_checks, :aliases => "healthChecks"
        attribute :instances, :aliases => "instances"
        attribute :session_affinity, :aliases => "sessionAffinity"
        attribute :failover_ratio, :aliases => "failoverRatio"
        attribute :backup_pool, :aliases => "backupPool"


        def save
          requires :name, :region, :instances

          options = {
            'description' => description,
            'region' => region,
            'health_checks' => health_checks,
            'instances' => instances,
            'session_affinity' => session_affinity,
            'failover_ratio' => failover_ratio,
            'backup_pool' => backup_pool
          }

          service.insert_target_pool(name, region, options).body
          data = service.backoff_if_unfound {service.get_target_pool(name, region).body}
          merge_attributes(data)
          self
        end

        def destroy
          requires :name, :region
          operation = service.delete_target_pool(name, region)
          # wait until "RUNNING" or "DONE" to ensure the operation doesn't fail, raises exception on error
          Fog.wait_for do
            operation = service.get_region_operation(region, operation.body["name"])
            operation.body["status"] != "PENDING"
          end
          operation
        end

        def add_instance instance
          # TODO(bensonk) write me
        end

        def add_http_health_check http_health_check
          # TODO(bensonk) write me
        end

        def get_health
          # TODO(bensonk) write me
        end

        def remove_http_health_check http_health_check
          # TODO(bensonk) write me
        end

        def remove_instance instance
          # TODO(bensonk) write me
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
