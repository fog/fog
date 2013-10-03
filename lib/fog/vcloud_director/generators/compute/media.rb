module Fog
  module Generators
    module Compute
      module VcloudDirector
        require 'fog/vcloud_director/generators/compute/resource_entity'

        # Represents a Media object.
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/MediaType.html
        #   vCloud API Documentation
        class Media < ResourceEntity

          # @param [String] name
          # @param [String] image_type
          # @param [Integer] size
          # @param [Hash] data
          def initialize(name, image_type, size, data={})
            super name, data
            @root_attributes[:name] = name
            @root_attributes[:imageType] = image_type
            @root_attributes[:size] = size
          end

        end
      end
    end
  end
end
