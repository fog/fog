require 'fog/core/model'

module Fog
  module Network
    class OpenStack
      class LbMember < Fog::Model
        identity :id

        attribute :pool_id
        attribute :address
        attribute :protocol_port
        attribute :weight
        attribute :status
        attribute :admin_state_up
        attribute :tenant_id

        def initialize(attributes)
          prepare_service_value(attributes)
          super
        end

        def save
          requires :pool_id, :address, :protocol_port, :weight
          identity ? update : create
        end

        def create
          requires :pool_id, :address, :protocol_port, :weight
          merge_attributes(service.create_lb_member(self.pool_id,
                                                    self.address,
                                                    self.protocol_port,
                                                    self.weight,
                                                    self.attributes).body['member'])
          self
        end

        def update
          requires :id, :pool_id, :address, :protocol_port, :weight
          merge_attributes(service.update_lb_member(self.id,
                                                    self.attributes).body['member'])
          self
        end

        def destroy
          requires :id
          service.delete_lb_member(self.id)
          true
        end

      end
    end
  end
end