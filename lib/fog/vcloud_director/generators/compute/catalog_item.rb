module Fog
  module Generators
    module Compute
      module VcloudDirector
        require 'fog/vcloud_director/generators/compute/entity'

        # Contains a reference to a VappTemplate or Media object and related metadata.
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/CatalogItemType.html
        #   vCloud API Documentation
        class CatalogItem < Entity

          attr_reader :entity

          # @param [String] name The name of the entity.
          # @param [String] entity_href Contains the URI to the entity.
          # @param [Hash] data
          def initialize(name, entity_href, data={})
            super name, data
            @root_attributes[:status] = data.delete(:status)
            @entity = {:href => entity_href}
          end

          protected

          def inner_build(xml)
            xml.Entity(entity)
          end
        end
      end
    end
  end
end
