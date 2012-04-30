require 'fog/core/model'

module Fog
  module Compute
    class OpenStack
      class Flavor < Fog::Model
        identity :id

        attribute :name
        attribute :ram
        attribute :disk
        attribute :vcpus
        attribute :links
        attribute :swap
        attribute :rxtx_factor
        attribute :ephemeral, :aliases => 'OS-FLV-EXT-DATA:ephemeral'

        def initialize(attributes)
          @connection = attributes[:connection]
          super
        end

        def save
          requires :name, :ram, :vcpus, :disk
          attributes[:ephemeral] = self.ephemeral || 0
          attributes[:swap] = self.swap || 0
          attributes[:rxtx_factor] = self.rxtx_factor || 1
          merge_attributes(connection.create_flavor(self.attributes).body['flavor'])
          self
        end

        def destroy
          requires :id
          connection.delete_flavor(self.id)
          true
        end
      end
    end
  end
end
