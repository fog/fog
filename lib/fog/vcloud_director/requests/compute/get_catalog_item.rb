module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a catalog item.
        #
        # @param [String] catalog_item_id Object identifier of the catalog
        #   item.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-CatalogItem.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def get_catalog_item(catalog_item_id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "catalogItem/#{catalog_item_id}"
          )
        end
      end
    end
  end
end
