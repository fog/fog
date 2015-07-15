require 'fog/openstack/models/model'

module Fog
  module Compute
    class OpenStack
      class Flavor < Fog::OpenStack::Model
        identity :id

        attribute :name
        attribute :ram
        attribute :disk
        attribute :vcpus
        attribute :links
        attribute :swap
        attribute :rxtx_factor
        attribute :metadata
        attribute :ephemeral, :aliases => 'OS-FLV-EXT-DATA:ephemeral'
        attribute :is_public, :aliases => 'os-flavor-access:is_public'
        attribute :disabled, :aliases => 'OS-FLV-DISABLED:disabled'

        def save
          requires :name, :ram, :vcpus, :disk
          attributes[:ephemeral] = self.ephemeral || 0
          attributes[:is_public] = self.is_public || false
          attributes[:disabled] = self.disabled || false
          attributes[:swap] = self.swap || 0
          attributes[:rxtx_factor] = self.rxtx_factor || 1.0
          merge_attributes(service.create_flavor(self.attributes).body['flavor'])
          self
        end

        def destroy
          requires :id
          service.delete_flavor(self.id)
          true
        end

        def metadata
          service.get_flavor_metadata(self.id).body['extra_specs']
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

        def create_metadata(metadata)
          service.create_flavor_metadata(self.id, metadata)
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
