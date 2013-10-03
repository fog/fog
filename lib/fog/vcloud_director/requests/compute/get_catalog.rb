module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a catalog.
        #
        # @param [String] catalog_id Object identifier of the catalog.
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

      class Mock
        def get_catalog(catalog_id)
          response = Excon::Response.new

          unless valid_uuid?(catalog_id)
            response.status = 400
            raise Excon::Error.status_error({:expects => 200}, response)
          end
          unless data[:catalogs].has_key?(catalog_id)
            response.status = 403
            raise Excon::Error.status_error({:expects => 200}, response)
          end

          Fog::Mock.not_implemented
        end
      end
    end
  end
end
