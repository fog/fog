module Fog
  module Compute
    class VcloudDirector
      class Real
        # Power on a vApp or VM.
        #
        # If used on a vApp, powers on all VMs in the vApp. If used on a VM,
        # powers on the VM. This operation is available only for a vApp or VM
        # that is powered off.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] vm_id ID of the vApp or VM to power on.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-PowerOnVApp.html
        #   vCloud Director API
        # @since vCloud API version 0.9
        def post_vm_poweron(vm_id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{vm_id}/power/action/powerOn"
          )
        end
      end
    end
  end
end
