module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the RASD item that specifies CPU properties of a VM.
        #
        # @param [String] vm_id
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-CpuRasdItem.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def get_vm_cpu(vm_id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{vm_id}/virtualHardwareSection/cpu"
          )
        end
      end
    end
  end
end
