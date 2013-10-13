module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve an edge gateway.
        #
        # @param [String] id Object identifier of the edge gateway.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-EdgeGateway.html
        #   vCloud API Documentation
        # @since vCloud API version 5.1
        def get_edge_gateway(id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::ToHashDocument.new,
            :path    => "admin/edgeGateway/#{id}"
          )
        end
      end

      class Mock
        def get_edge_gateway(id)
          response = Excon::Response.new

          unless valid_uuid?(id)
            response.status = 400
            raise Excon::Errors.status_error({:expects => 200}, response)
          end
          unless edge_gateway = data[:edge_gateways][id]
            response.status = 403
            raise Excon::Errors.status_error({:expects => 200}, response)
          end

          vdc_id = edge_gateway[:vdc]

          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :status => "1",
            :name => edge_gateway[:name],
            :id => "urn:vcloud:gateway:27805d5d-868b-4678-b30b-11e14ad34eca",
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
            :Configuration =>
             {:GatewayBackingConfig => "compact",
              :GatewayInterfaces =>
               {:GatewayInterface => []},
              :EdgeGatewayServiceConfiguration =>
               {:FirewallService =>
                {:IsEnabled => "true",
                 :DefaultAction => "drop",
                 :LogDefaultAction => "false"},
                :NatService => {:IsEnabled => "true"}},
              :HaEnabled => "false",
              :UseDefaultRouteForDnsRelay => "false"}}

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

          response.status = 200
          response.headers = {'Content-Type' => "#{body[:type]};version=#{api_version}"}
          response.body = body
          response
        end
      end
    end
  end
end
