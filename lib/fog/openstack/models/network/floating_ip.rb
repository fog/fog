require 'fog/core/model'

module Fog
  module Network
    class OpenStack
      class FloatingIp < Fog::Model
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
          merge_attributes(connection.create_floating_ip(self.floating_network_id,


                                                    self.attributes).body['floating_ip'])
          self
        end

        def update
          self
        end

        def destroy
          requires :id
          connection.delete_floating_ip(self.id)
          true
        end

      end
    end
  end
end
