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
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Catalog.html
        # @since vCloud API version 0.9
        def get_catalog(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "catalog/#{id}"
          )
          ensure_list! response.body, :CatalogItems, :CatalogItem
          response
        end
      end

      class Mock
        def get_catalog(id)
          unless catalog = data[:catalogs][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.catalog:#{id})\"."
            )
          end

          Fog::Mock.not_implemented
          catalog.is_used_here # avoid warning from syntax checker
        end
      end
    end
  end
end
