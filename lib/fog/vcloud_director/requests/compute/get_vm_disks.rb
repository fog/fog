module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/disks'

        # Retrieve all RASD items that specify hard disk and hard disk
        # controller properties of a VM.
        #
        # @param [String] vm_id
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-DisksRasdItemsList.html
        #   vCloud API Documentation
        def get_vm_disks(vm_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::Parsers::Compute::VcloudDirector::Disks.new,
            :path    => "vApp/#{vm_id}/virtualHardwareSection/disks"
          )
        end
      end
    end
  end
end
