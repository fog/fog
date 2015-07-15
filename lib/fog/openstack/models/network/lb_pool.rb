require 'fog/openstack/models/model'

module Fog
  module Network
    class OpenStack
      class LbPool < Fog::OpenStack::Model
        identity :id

        attribute :subnet_id
        attribute :protocol
        attribute :lb_method
        attribute :name
        attribute :description
        attribute :health_monitors
        attribute :members
        attribute :status
        attribute :admin_state_up
        attribute :vip_id
        attribute :tenant_id
        attribute :active_connections
        attribute :bytes_in
        attribute :bytes_out
        attribute :total_connections

        def create
          requires :subnet_id, :protocol, :lb_method
          merge_attributes(service.create_lb_pool(self.subnet_id,
                                                  self.protocol,
                                                  self.lb_method,
                                                  self.attributes).body['pool'])
          self
        end

        def update
          requires :id, :subnet_id, :protocol, :lb_method
          merge_attributes(service.update_lb_pool(self.id,
                                                  self.attributes).body['pool'])
          self
        end

        def destroy
          requires :id
          service.delete_lb_pool(self.id)
          true
        end

        def stats
          requires :id
          merge_attributes(service.get_lb_pool_stats(self.id).body['stats'])
          self
        end

        def associate_health_monitor(health_monitor_id)
          requires :id
          service.associate_lb_health_monitor(self.id, health_monitor_id)
          true
        end

        def disassociate_health_monitor(health_monitor_id)
          requires :id
          service.disassociate_lb_health_monitor(self.id, health_monitor_id)
          true
        end
      end
    end
  end
end
