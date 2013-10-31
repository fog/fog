module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve an edge gateway.
        #
        # @param [String] id Object identifier of the edge gateway.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-EdgeGateway.html
        # @since vCloud API version 5.1
        def get_edge_gateway(id)
          response = request(
              :expects => 200,
              :idempotent => true,
              :method => 'GET',
              :parser => Fog::ToHashDocument.new,
              :path => "admin/edgeGateway/#{id}"
          )

          ensure_list! response.body[:Configuration], :GatewayInterfaces, :GatewayInterface

          edge_gateway_service_configuration = response.body[:Configuration][:EdgeGatewayServiceConfiguration]

          ensure_list! edge_gateway_service_configuration[:FirewallService], :FirewallRule if edge_gateway_service_configuration[:FirewallService]
          ensure_list! edge_gateway_service_configuration[:NatService], :NatRule if edge_gateway_service_configuration[:NatService]

          if edge_gateway_service_configuration[:LoadBalancerService]

            ensure_list! edge_gateway_service_configuration[:LoadBalancerService], :Pool
            edge_gateway_service_configuration[:LoadBalancerService][:Pool].each do |pool|
              ensure_list! pool, :ServicePort
              ensure_list! pool, :Member
              pool[:Member].each do |member|
                ensure_list! member, :ServicePort
              end
            end

            ensure_list! edge_gateway_service_configuration[:LoadBalancerService], :VirtualServer
            edge_gateway_service_configuration[:LoadBalancerService][:VirtualServer].each do |virtual_server|
              ensure_list! virtual_server, :ServiceProfile
            end

          end

          response
        end
      end

      class Mock
        def get_edge_gateway(id)
          unless edge_gateway = data[:edge_gateways][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.gateway:#{id})\""
            )
          end

          vdc_id = edge_gateway[:vdc]
          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :status => "1",
            :name => edge_gateway[:name],
            :id => "urn:vcloud:gateway:#{id}",
            :type => "application/vnd.vmware.admin.edgeGateway+xml",
            :href => make_href("admin/edgeGateway/#{id}"),
            :xsi_schemaLocation => xsi_schema_location,
            :Link =>[{:rel => "up",
                      :type => "application/vnd.vmware.vcloud.vdc+xml",
                      :href => make_href("vdc/#{vdc_id}")},
                     {:rel => "edgeGateway:redeploy",
                      :href => make_href("admin/edgeGateway/#{id}/action/redeploy")},
                     {:rel => "edgeGateway:configureServices",
                      :type => "application/vnd.vmware.admin.edgeGatewayServiceConfiguration+xml",
                      :href => make_href("admin/edgeGateway/#{id}/action/configureServices")},
                     {:rel => "edgeGateway:reapplyServices",
                      :href => make_href("admin/edgeGateway/#{id}/action/reapplyServices")},
                     {:rel => "edgeGateway:syncSyslogSettings",
                      :href => make_href("admin/edgeGateway/#{id}/action/syncSyslogServerSettings")}],
            :Description => "vCloud CI (nft00052i2)",
            :Configuration => edge_gateway[:Configuration].dup
          }

          body[:Configuration][:GatewayInterfaces][:GatewayInterface] += edge_gateway[:networks].map do |network|
            extras = {
              :Network => {
                :type => "application/vnd.vmware.admin.network+xml",
                :name => "anything",
                :href => make_href("admin/network/#{network}")
              },
              :Name => data[:networks][network][:name],
              :DisplayName => data[:networks][network][:name]
            }
            data[:networks][network].merge extras
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
