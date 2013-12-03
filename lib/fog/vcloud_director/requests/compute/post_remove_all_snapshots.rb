module Fog
  module Compute
    class VcloudDirector
      class Real
        # Removes all user created snapshots for a vApp or virtual machine.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vApp or virtual machine.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-RemoveAllSnapshots.html
        # @since vCloud API version 5.1
        def post_remove_all_snapshots(id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/action/removeAllSnapshots"
          )
        end
      end
    end
  end
end
