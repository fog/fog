module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a catalog.
        #
        # @param [String] id Object identifier of the catalog.
        # @return [Excon::Response]
        #   * hash<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Catalog.html
        # @since vCloud API version 0.9
        def get_catalog(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "catalog/#{id}"
          )
        end
      end

      class Mock
        def get_catalog(id)
          response = Excon::Response.new

          unless valid_uuid?(id)
            response.status = 400
            raise Excon::Error.status_error({:expects => 200}, response)
          end
          unless catalog = data[:catalogs][id]
            response.status = 403
            raise Excon::Error.status_error({:expects => 200}, response)
          end

          Fog::Mock.not_implemented
          catalog.is_used_here # avoid warning from syntax checker
        end
      end
    end
  end
end
