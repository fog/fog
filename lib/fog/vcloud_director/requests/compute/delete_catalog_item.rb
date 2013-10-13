module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete a catalog item.
        #
        # @param [String] id Object identifier of the catalog item.
        # @return [Excon::Response]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-CatalogItem.html
        # @since vCloud API version 0.9
        def delete_catalog_item(id)
          request(
            :expects => 204,
            :method  => 'DELETE',
            :path    => "catalogItem/#{id}"
          )
        end
      end
    end
  end
end
