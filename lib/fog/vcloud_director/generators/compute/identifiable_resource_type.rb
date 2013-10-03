module Fog
  module Generators
    module Compute
      module VcloudDirector
        require 'fog/vcloud_director/generators/compute/resource_type'

        # The base type for all resource types which contain an id attribute.
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/IdentifiableResourceType.html
        #   vCloud API Documentation
        class IdentifiableResourceType < ResourceType

          # @param [Hash] data
          # @option data [String] :href The URI of the entity.
          # @option data [String] :type The MIME type of the entity.
          # @option data [String] :operationKey Optional unique identifier to
          #   support idempotent semantics for create and delete operations.
          def initialize(data={})
            super
            @root_attributes[:operationKey] = data.delete(:operationKey) # since 5.1
          end
        end
      end
    end
  end
end
