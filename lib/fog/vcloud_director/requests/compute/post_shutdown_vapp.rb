module Fog
  module Compute
    class VcloudDirector
      class Real
        # Shut down a vApp or VM.
        #
        # If used on a vApp, shuts down all VMs in the vApp. If used on a VM,
        # shuts down the VM. This operation is available only for a vApp or VM
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
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-ShutdownVApp.html
        # @since vCloud API version 0.9
        def post_shutdown_vapp(id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/power/action/shutdown"
          )
        end
      end
    end
  end
end
