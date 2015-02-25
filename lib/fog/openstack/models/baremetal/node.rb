require 'fog/core/model'

module Fog
  module Baremetal
    class OpenStack
      class Node < Fog::Model
        identity :uuid

        attribute :instance_uuid
        attribute :maintenance
        attribute :power_state
        attribute :provision_state
        attribute :uuid

        #detailed
        attribute :created_at
        attribute :updated_at
        attribute :chassis_uuid
        attribute :console_enabled
        attribute :driver
        attribute :driver_info
        attribute :extra
        attribute :instance_info
        attribute :last_error
        attribute :maintenance_reason
        attribute :properties
        attribute :provision_updated_at
        attribute :reservation
        attribute :target_power_state
        attribute :target_provision_state

        def initialize(attributes)
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def save
          requires :driver
          identity ? update : create
        end

        def create
          requires :driver
          merge_attributes(service.create_node(self.attributes).body)
          self
        end

        def update(patch=nil)
          requires :uuid
          if patch
            merge_attributes(service.patch_node(uuid, patch).body)
          else
            # TODO implement update_node method using PUT method and self.attributes
            # once it is supported by Ironic
            raise ArgumentError, ('You need to provide patch attribute. Ironic does '
                                  'not support update by hash yet, only by jsonpatch.')
          end
          self
        end

        def destroy
          requires :uuid
          service.delete_node(self.uuid)
          true
        end

        def chassis
          requires :uuid
          service.get_chassis(self.chassis_uuid).body
        end

        def ports
          requires :uuid
          service.list_ports_detailed({:node_uuid => self.uuid}).body['ports']
        end

        def metadata
          requires :uuid
          service.get_node(self.uuid).headers
        end
      end
    end
  end
end
