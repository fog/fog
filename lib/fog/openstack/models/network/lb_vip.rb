require 'fog/core/model'

module Fog
  module Network
    class OpenStack
      class LbVip < Fog::Model
        identity :id

        attribute :subnet_id
        attribute :pool_id
        attribute :protocol
        attribute :protocol_port
        attribute :name
        attribute :description
        attribute :address
        attribute :port_id
        attribute :session_persistence
        attribute :connection_limit
        attribute :status
        attribute :admin_state_up
        attribute :tenant_id

        def initialize(attributes)
          prepare_service_value(attributes)
          super
        end

        def save
          requires :subnet_id, :pool_id, :protocol, :protocol_port
          identity ? update : create
        end

        def create
          requires :subnet_id, :pool_id, :protocol, :protocol_port
          merge_attributes(service.create_lb_vip(self.subnet_id,
                                                 self.pool_id,
                                                 self.protocol,
                                                 self.protocol_port,
                                                 self.attributes).body['vip'])
          self
        end

        def update
          requires :id, :subnet_id, :pool_id, :protocol, :protocol_port
          merge_attributes(service.update_lb_vip(self.id,
                                                 self.attributes).body['vip'])
          self
        end

        def destroy
          requires :id
          service.delete_lb_vip(self.id)
          true
        end

      end
    end
  end
end
