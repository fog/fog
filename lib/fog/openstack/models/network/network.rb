require 'fog/core/model'

module Fog
  module Network
    class OpenStack
      class Network < Fog::Model
        identity :id

        attribute :name
        attribute :subnets
        attribute :shared
        attribute :status
        attribute :admin_state_up
        attribute :tenant_id

        def initialize(attributes)
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def save
          identity ? update : create
        end

        def create
          merge_attributes(connection.create_network(self.attributes).body['network'])
          self
        end

        def update
          requires :id
          merge_attributes(connection.update_network(self.id,
                                                     self.attributes).body['network'])
          self
        end

        def destroy
          requires :id
          connection.delete_network(self.id)
          true
        end

      end
    end
  end
end
