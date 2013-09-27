module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the RASD item that specifies memory properties of a VM.
        #
        # @param [String] vm_id
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-MemoryRasdItem.html
        #   vCloud API Documentation
        def get_vm_memory(vm_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{vm_id}/virtualHardwareSection/memory"
          )
        end
      end
    end
  end
end
