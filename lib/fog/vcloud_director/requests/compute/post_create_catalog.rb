module Fog
  module Compute
    class VcloudDirector
      class Real
        # Create a catalog.
        #
        # @param [String] id Object identifier of the Organization.
        # @param [String] catalog_name Name of the catalog to be created.
        # @param [String] catalog_name Description of the catalog to be created.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CreateCatalog.html
        # @since vCloud API version 0.9
        def post_create_catalog(id, catalog_name, catalog_description)

          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              :name => catalog_name
            }
          AdminCatalog(attrs) {
            Description catalog_description
          }
          end.to_xml

          begin
            request(
              :body    => body,
              :expects => 201,
              :headers => {'Content-Type' => 'application/vnd.vmware.admin.catalog+xml'},
              :method  => 'POST',
              :parser  => Fog::ToHashDocument.new,
              :path    => "/admin/org/#{id}/catalogs"
            )
          rescue Fog::Compute::VcloudDirector::BadRequest => e
            if e.minor_error_code == 'DUPLICATE_NAME'
              raise Fog::Compute::VcloudDirector::DuplicateName.new(e.message)
            end
            raise
          end
        end
      end
    end
  end
end