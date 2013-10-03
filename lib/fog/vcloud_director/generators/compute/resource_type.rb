module Fog
  module Generators
    module Compute
      module VcloudDirector
        require 'fog/vcloud_director/generators/compute/base'

        # The base type for all objects in the vCloud model. Has an optional
        #   list of links and href and type attributes.
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/ResourceType.html
        #   vCloud API Documentation
        class ResourceType < Base

          # @param [Hash] data
          # @option data [String] :href The URI of the entity.
          # @option data [String] :data The MIME type of the entity.
          def initialize(data={})
            super
            @root_attributes[:xmlns] = 'http://www.vmware.com/vcloud/v1.5'
            @root_attributes[:href] = data.delete(:href)
            @root_attributes[:type] = data.delete(:type)
          end

          protected

          def inner_build(xml)
          end
        end
      end
    end
  end
end
