require 'fog/core/model'

module Fog
  module Network
    class OpenStack
      class Floatingip < Fog::Model
        identity :id

        attribute :floating_network_id
        attribute :port_id
        attribute :tenant_id
        attribute :fixed_ip_address







        def initialize(attributes)
          @connection = attributes[:connection]
          super
        end

        def save
          requires :floating_network_id
          identity ? update : create
        end

        def create
          requires :floating_network_id
          merge_attributes(connection.create_floatingip(self.floating_network_id,


                                                    self.attributes).body['floatingip'])
          self
        end

        def update
          requires :id, :floating_network_id
          merge_attributes(connection.update_floatingip(self.floating_network_id,
                                                    self.attributes).body['floatingip'])
          self
        end

        def destroy
          requires :id
          connection.delete_floatingip(self.id)
          true
        end

        def assosiate
          requires :floating_network_id
          merge_attributes(connection.assosiate_floatingip(self.floating_network_id,
                                                    self.port_id,
                                                    self.attributes).body['floatingip'])
          self
        end

        def disassosiate
          requires :floating_network_id
          connection.disassosiate_floatingip(self.floating_network_id)
          self
        end
      end
    end
  end
end
