module Fog
  module Compute
    class VcloudDirector
      class Real

        require 'fog/vcloud_director/generators/compute/edge_gateway'

        def post_configure_edge_gateway(id, configuration)
          body = Fog::Generators::Compute::VcloudDirector::EdgeGateway.new(configuration).generate_xml

          request(
              :body => body,
              :expects => 202,
              :headers => {'Content-Type' => 'application/vnd.vmware.admin.edgeGatewayServiceConfiguration+xml'},
              :method => 'POST',
              :parser => Fog::ToHashDocument.new,
              :path => "admin/edgeGateway/#{id}/action/configureServices"
          )
        end

      end
    end
  end
end

