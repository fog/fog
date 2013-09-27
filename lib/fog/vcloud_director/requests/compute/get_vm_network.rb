module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/vm_network'

        # Retrieve the network connection section of a VM.
        #
        # @param [String] vm_id
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-NetworkConnectionSystemSection-vApp.html
        #   vCloud API Documentation
        def get_vm_network(vm_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::Parsers::Compute::VcloudDirector::VmNetwork.new,
            :path    => "vApp/#{vm_id}/networkConnectionSection/"
          )
        end
      end
    end
  end
end
