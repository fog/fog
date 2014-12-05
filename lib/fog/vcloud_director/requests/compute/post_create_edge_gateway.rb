module Fog
  module Compute
    class VcloudDirector
      class Real
        # Create a new edge gateway.
        #
        # @param  [String] name The name of the new edge gatway.
        #
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise Fog::Compute::VcloudDirector::DuplicateName
        #
        # @see https://pubs.vmware.com/vcd-51/index.jsp?topic=%2Fcom.vmware.vcloud.api.reference.doc_51%2Fdoc%2Ftypes%2FGatewayType.html
        # @since vCloud API version 0.9
        def post_create_edge_gateway(vdc_id, name, options = {})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              :name => name,
            }

            EdgeGateway(attrs) {
              if options[:description]
                Description options[:description]
              end
            }
          end.to_xml

          begin
            request(
              :body    => body,
              :expects => 201,
              :headers => {'Content-Type' => 'application/vnd.vmware.admin.edgeGateway+xml'},
              :method  => 'POST',
              :parser  => Fog::ToHashDocument.new,
              :path    => "admin/vdc/#{vdc_id}/edgeGateways"
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
