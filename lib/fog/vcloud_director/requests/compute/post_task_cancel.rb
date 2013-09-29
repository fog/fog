module Fog
  module Compute
    class VcloudDirector
      class Real
        # Cancel a task.
        #
        # @param [String] task_id
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CancelTask.html
        #   vCloud API Documentation
        # @since vCloud API version 1.5
        def post_task_cancel(task_id)
          request(
            :expects => 204,
            :method  => 'POST',
            :path    => "task/#{task_id}/action/cancel"
          )
        end
      end
    end
  end
end
