module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve all catalog metadata.
        #
        # @param [String] id Object identifier of the catalog.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-CatalogMetadata.html
        # @since vCloud API version 1.5
        def get_catalog_metadata(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "catalog/#{id}/metadata"
          )
        end
      end
    end
  end
end
