module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/vm_network'

        # Retrieve the network connection section of a VM.
        #
        # @deprecated Use {#get_network_connection_system_section_vapp}
        #   instead.
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-NetworkConnectionSystemSection-vApp.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        # @todo Log deprecation warning.
        def get_vm_network(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Compute::VcloudDirector::VmNetwork.new,
            :path       => "vApp/#{id}/networkConnectionSection/"
          )
        end
      end
    end
  end
end
