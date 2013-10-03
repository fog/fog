module Fog
  module Generators
    module Compute
      module VcloudDirector
        require 'fog/vcloud_director/generators/compute/identifiable_resource_type'

        # Basic entity type in the vCloud object model. Includes a name, an
        #   optional description, and an optional list of links.
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/EntityType.html
        #   vCloud API Documentation
        class Entity < IdentifiableResourceType

          # @param [String] name The name of the entity.
          # @param [Hash] data
          def initialize(name, data={})
            super data
            @root_attributes[:name] = name
          end

          protected

          def inner_build(xml)
            super
            xml.Description data.delete(:Description)
          end

        end
      end
    end
  end
end
