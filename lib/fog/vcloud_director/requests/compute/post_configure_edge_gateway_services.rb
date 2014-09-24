module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/edge_gateway_service_configuration'

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
          body = Fog::Generators::Compute::VcloudDirector::EdgeGatewayServiceConfiguration.new(configuration).generate_xml

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

      class Mock
        def post_configure_edge_gateway_services(id, configuration)
          unless data[:edge_gateways][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
                      "No access to entity \"(com.vmware.vcloud.entity.edgegateway:#{id})\"."
                  )
          end

          owner = {
            :href => make_href("admin/edgeGateway/#{id}"),
            :type => 'application/vnd.vmware.vcloud.gateway+xml'
          }
          task_id = enqueue_task(
              "Configuring edgegateway(#{id})", 'networkConfigureEdgeGatewayServices', owner,
              :on_success => lambda do
                data[:edge_gateways][id][:Configuration][:EdgeGatewayServiceConfiguration] = configuration
              end
          )

          task = task_body(task_id)
          task.delete(:Owner)  # known bug - admin tasks do not return Owner

          body = {
              :xmlns => xmlns,
              :xmlns_xsi => xmlns_xsi,
              :xsi_schemaLocation => xsi_schema_location,
          }.merge(task)

          Excon::Response.new(
              :status => 202,
              :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
              :body => body
          )
        end
      end
    end
  end
end
