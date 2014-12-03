module Fog
  module Compute
    class VcloudDirector
      class Real
        # Create a new catalog.
        #
        # @param  [String] name The name of the new catalog.
        # @param  [String] org_id Unique identifier for the organization to create catalog in.
        # @option [String] description Optional description.
        #
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise Fog::Compute::VcloudDirector::DuplicateName
        #
        # @see http://pubs.vmware.com/vcd-51/index.jsp#com.vmware.vcloud.api.doc_51/GUID-AAFD7FC1-446D-41F7-8CC2-7715D05F2EA2.html
        # @since vCloud API version 0.9
        def post_create_catalog(name, org_id, description = nil)
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              :name => name,
            }

            AdminCatalog(attrs) {
              if description
                Description description
              end
            }
          end.to_xml

          begin
            request(
              :body    => body,
              :expects => 201,
              :headers => {'Content-Type' => 'application/vnd.vmware.admin.catalog+xml'},
              :method  => 'POST',
              :parser  => Fog::ToHashDocument.new,
              :path    => "admin/org/#{org_id}/catalogs"
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
