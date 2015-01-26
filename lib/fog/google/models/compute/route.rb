require 'fog/core/model'

module Fog
  module Compute
    class Google
      ##
      # Represents a Route resource
      #
      # @see https://developers.google.com/compute/docs/reference/latest/routes
      class Route < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description
        attribute :dest_range, :aliases => 'destRange'
        attribute :network
        attribute :next_hop_gateway, :aliases => 'nextHopGateway'
        attribute :next_hop_instance, :aliases => 'nextHopInstance'
        attribute :next_hop_ip, :aliases => 'nextHopIp'
        attribute :next_hop_network, :aliases => 'nextHopNetwork'
        attribute :priority
        attribute :self_link, :aliases => 'selfLink'
        attribute :tags
        attribute :warnings

        def save
          requires :identity, :network, :dest_range, :priority

          data = service.insert_route(identity, self.network, self.dest_range, self.priority, self.attributes)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async=true)
          requires :identity

          data = service.delete_route(identity)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'])
          unless async
            operation.wait_for { ready? }
          end
          operation
        end
      end
    end
  end
end
