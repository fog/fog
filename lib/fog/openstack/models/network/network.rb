require 'fog/openstack/models/model'

module Fog
  module Network
    class OpenStack
      class Network < Fog::OpenStack::Model
        identity :id

        attribute :name
        attribute :subnets
        attribute :shared
        attribute :status
        attribute :admin_state_up
        attribute :tenant_id
        attribute :provider_network_type,     :aliases => 'provider:network_type'
        attribute :provider_physical_network, :aliases => 'provider:physical_network'
        attribute :provider_segmentation_id,  :aliases => 'provider:segmentation_id'
        attribute :router_external,           :aliases => 'router:external'

        def subnets
          service.subnets.select {|s| s.network_id == self.id }
        end

        def create
          merge_attributes(service.create_network(self.attributes).body['network'])
          self
        end

        def update
          requires :id
          merge_attributes(service.update_network(self.id, self.attributes).body['network'])
          self
        end

        def destroy
          requires :id
          service.delete_network(self.id)
          true
        end
      end
    end
  end
end
