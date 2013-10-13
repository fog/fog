module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve all metadata associated with a catalog item.
        #
        # @param [String] id Object identifier of the catalog item.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-CatalogItemMetadata.html
        # @since vCloud API version 1.5
        def get_catalog_item_metadata(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "catalogItem/#{id}/metadata"
          )
        end
      end
    end
  end
end
