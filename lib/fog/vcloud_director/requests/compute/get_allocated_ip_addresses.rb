module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a list of IP addresses allocated to the network.
        #
        # @param [String] id Object identifier of the network.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-AllocatedIpAddresses.html
        # @since vCloud API version 5.1
        def get_allocated_ip_addresses(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "network/#{id}/allocatedAddresses"
          )
        end
      end
    end
  end
end
