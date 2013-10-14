module Fog
  module Compute
    class VcloudDirector
      class Real
        # Reboot a vApp or VM.
        #
        # If used on a vApp, reboots all VMs in the vApp. If used on a VM,
        # reboots the VM. This operation is available only for a vApp or VM
        # that is powered on.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::BadRequest]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-RebootVApp.html
        # @since vCloud API version 0.9
        def post_reboot_vapp(id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/power/action/reboot"
          )
        end
      end
    end
  end
end
