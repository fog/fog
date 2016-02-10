require 'fog/openstack/models/model'

module Fog
  module Network
    class OpenStack
      class LbHealthMonitor < Fog::OpenStack::Model
        identity :id

        attribute :type
        attribute :delay
        attribute :timeout
        attribute :max_retries
        attribute :http_method
        attribute :url_path
        attribute :expected_codes
        attribute :status
        attribute :admin_state_up
        attribute :tenant_id

        def create
          requires :type, :delay, :timeout, :max_retries
          merge_attributes(service.create_lb_health_monitor(self.type,
                                                            self.delay,
                                                            self.timeout,
                                                            self.max_retries,
                                                            self.attributes).body['health_monitor'])
          self
        end

        def update
          requires :id, :type, :delay, :timeout, :max_retries
          merge_attributes(service.update_lb_health_monitor(self.id,
                                                            self.attributes).body['health_monitor'])
          self
        end

        def destroy
          requires :id
          service.delete_lb_health_monitor(self.id)
          true
        end

        def associate_to_pool(pool_id)
          requires :id
          service.associate_lb_health_monitor(pool_id, self.id)
          true
        end

        def disassociate_from_pool(pool_id)
          requires :id
          service.disassociate_lb_health_monitor(pool_id, self.id)
          true
        end
      end
    end
  end
end
