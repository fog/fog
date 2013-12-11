module Fog
  module Compute
    class VcloudDirector
      class Real
        # Reverts a vApp or virtual machine to the current snapshot, if any.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vApp or virtual machine.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-RevertSnapshot.html
        # @since vCloud API version 5.1
        def post_revert_snapshot(id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/action/revertToCurrentSnapshot"
          )
        end
      end
    end
  end
end
