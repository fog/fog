module Fog
  module Compute
    class VcloudDirector
      class Real

        require 'fog/vcloud_director/generators/compute/edge_gateway'

        # Configure edge gateway services like firewall, nat and load balancer.
        #
        # The response includes a Task element. You can monitor the task to
        # track the configuration of edge gateway services.
        #
        # @param [String] id Object identifier of the edge gateway.
        # @param [Hash] configuration
        # @configuration firewall_service [Hash] - configurations for firewall service.
        # @configuration nat_service [Hash] - configurations for NAT network service.
        # @configuration load_balancer_service [Hash] - configurations for load balancer service
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see https://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-ConfigureEdgeGatewayServices.html
        #   vCloud API Documentaion
        # @since vCloud API version 5.1
        def post_configure_edge_gateway_services(id, configuration)
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

