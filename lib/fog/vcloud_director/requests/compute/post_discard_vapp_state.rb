module Fog
  module Compute
    class VcloudDirector
      class Real
        # Discard suspended state of a vApp or VM.
        #
        # Discarding the suspended state of a vApp discards the suspended state
        # of all VMs it contains.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-DiscardVAppState.html
        # @since vCloud API version 0.9
        def post_discard_vapp_state(id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/action/discardSuspendedState"
          )
        end
      end
    end
  end
end
