module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :get_vm_cpu, :get_cpu_rasd_item

        # Retrieve the RASD item that specifies CPU properties of a VM.
        #
        # @param [String] vm_id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-CpuRasdItem.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def get_cpu_rasd_item(vm_id)
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
