module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/network'

        # Retrieve an organization network.
        #
        # @param [String] network_id ID of the network to retrieve.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Network.html
        #   vCloud API Documentation
        def get_network(network_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::Parsers::Compute::VcloudDirector::Network.new,
            :path    => "network/#{network_id}"
          )
        end
      end
    end
  end
end

