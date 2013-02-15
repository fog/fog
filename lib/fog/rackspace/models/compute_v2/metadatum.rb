require 'fog/core/model'
require 'fog/rackspace/models/compute_v2/meta_parent'

module Fog
  module Compute
    class RackspaceV2
      class Metadatum < Fog::Model

        include Fog::Compute::RackspaceV2::MetaParent

        identity :key
        attribute :value

        # Remove metadatum from server
        # @return [Boolean] return true if metadatum is deleting
        def destroy
          requires :identity
          connection.delete_metadata_item(collection_name, parent.id, key)
          true
        end

        # Save metadatum on server
        # @return [Boolean] return true if metadatum is saving
        def save
          requires :identity, :value
          connection.set_metadata_item(collection_name, parent.id, key, value)
          true
        end

      end
    end
  end
end
