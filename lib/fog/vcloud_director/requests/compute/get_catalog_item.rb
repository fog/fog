module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a catalog.
        #
        # @param [String] catalog_item_id ID of the catalog item to retrieve.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Catalog.html
        #   vCloud API Documentation
        def get_catalog_item(catalog_item_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::ToHashDocument.new,
            :path    => "catalogItem/#{catalog_item_id}"
          )
        end
      end
    end
  end
end
