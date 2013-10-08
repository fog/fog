module Fog
  module Compute
    class VcloudDirector
      class Real
        # List all gateways for this Org vDC.
        #
        # @param [String] vdc_id Object identifier of the VDC
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-OrgVdcGateways.html
        #   vCloud API Documentation
        # @since vCloud API version 5.1
        def get_edge_gateways(vdc_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::ToHashDocument.new,
            :path    => "admin/vdc/#{vdc_id}/edgeGateways"
          )
        end
      end

      class Mock
        def get_edge_gateways(vdc_id)
          response = Excon::Response.new

          unless valid_uuid?(vdc_id)
            response.status = 400
            raise Excon::Errors.status_error({:expects => 200}, response)
          end
          unless vdc = data[:vdcs][vdc_id]
            response.status = 403
            raise Excon::Errors.status_error({:expects => 200}, response)
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

          response.status = 200
          response.headers = {'Content-Type' => "#{body[:type]};version=#{api_version}"}
          response.body = body
          response
        end
      end
    end
  end
end
