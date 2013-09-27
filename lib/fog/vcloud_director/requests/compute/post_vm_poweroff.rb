module Fog
  module Compute
    class VcloudDirector
      class Real
        # Power off a vApp or VM.
        #
        # If used on a vApp, powers off all VMs in the vApp. If used on a VM,
        # powers off the VM. This operation is available only for a vApp or VM
        # that is powered on.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] vm_id ID of the vApp or VM to power off.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-PowerOffVApp.html
        #   vCloud API Documentation
        def post_vm_poweroff(vm_id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{vm_id}/power/action/powerOff"
          )
        end
      end
    end
  end
end
