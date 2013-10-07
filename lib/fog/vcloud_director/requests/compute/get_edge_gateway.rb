module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve an edge gateway
        #
        # @param [String] id Object identifier of the Edge Gateway
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
    end
  end
end

