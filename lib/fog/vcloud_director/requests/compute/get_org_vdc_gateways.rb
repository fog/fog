module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :get_edge_gateways, :get_org_vdc_gateways

        # List all gateways for this Org vDC.
        #
        # @param [String] id Object identifier of the vDC.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-OrgVdcGateways.html
        # @since vCloud API version 5.1
        def get_org_vdc_gateways(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "admin/vdc/#{id}/edgeGateways"
          )
          ensure_list! response.body, :EdgeGatewayRecord
          response
        end
      end

      class Mock
        def get_org_vdc_gateways(vdc_id)
          unless data[:vdcs][vdc_id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.vdc:#{vdc_id})\"."
            )
          end

          body =
            {:xmlns => xmlns,
             :xmlns_xsi => xmlns_xsi,
             :total => "1",
             :pageSize => "25",
             :page => "1",
             :name => "edgeGateways",
             :type => "application/vnd.vmware.vcloud.query.records+xml",
             :href => make_href("admin/vdc/#{vdc_id}edgeGateways?page=1&pageSize=25&format=records"),
             :xsi_schemaLocation => xsi_schema_location,
             :Link =>
              [{:rel => "alternate",
                :type => "application/vnd.vmware.vcloud.query.references+xml",
                :href => make_href("admin/vdc/#{vdc_id}edgeGateways?page=1&pageSize=25&format=references")},
               {:rel => "alternate",
                :type => "application/vnd.vmware.vcloud.query.idrecords+xml",
                :href => make_href("admin/vdc/#{vdc_id}edgeGateways?page=1&pageSize=25&format=records")}],
             :EdgeGatewayRecord => []}

          vdc_edge_gateways = data[:edge_gateways].select do |id, edge_gateway|
            edge_gateway[:vdc] == vdc_id
          end

          body[:EdgeGatewayRecord] += vdc_edge_gateways.map do |id, edge_gateway|
            {:vdc => make_href("vdc/#{vdc_id}"),
             :numberOfOrgNetworks => "1",
             :numberOfExtNetworks => "1",
             :name => edge_gateway[:name],
             :isBusy => "false",
             :haStatus => "DISABLED",
             :gatewayStatus => "READY",
             :href => make_href("admin/edgeGateway/#{id}"),
             :isSyslogServerSettingInSync => "true"}
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
