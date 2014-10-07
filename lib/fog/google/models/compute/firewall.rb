require 'fog/core/model'

module Fog
  module Compute
    class Google
      ##
      # Represents a Firewall resource
      #
      # @see https://developers.google.com/compute/docs/reference/latest/firewalls
      class Firewall < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :allowed
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description
        attribute :network
        attribute :self_link, :aliases => 'selfLink'
        attribute :source_ranges, :aliases => 'sourceRanges'
        attribute :source_tags, :aliases => 'sourceTags'
        attribute :target_tags, :aliases => 'targetTags'

        def save
          requires :identity, :allowed, :network

          data = service.insert_firewall(identity, self.allowed, self.network, self.attributes)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async=true)
          requires :identity

          data = service.delete_firewall(identity)
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
