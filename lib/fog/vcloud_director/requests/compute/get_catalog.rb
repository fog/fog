module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a catalog.
        #
        # @param [String] catalog_id ID of the catalog to retrieve.
        # @return [Excon::Response]
        #   * hash<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Catalog.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def get_catalog(catalog_id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "catalog/#{catalog_id}"
          )
        end
      end
    end
  end
end
