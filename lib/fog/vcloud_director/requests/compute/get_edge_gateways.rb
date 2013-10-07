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
    end
  end
end
