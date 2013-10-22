module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :post_task_cancel, :post_cancel_task

        # Cancel a task.
        #
        # @param [String] id Object identifier of the task.
        # @return [Excon::Response]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CancelTask.html
        # @since vCloud API version 1.5
        def post_cancel_task(id)
          request(
            :expects => 204,
            :method  => 'POST',
            :path    => "task/#{id}/action/cancel"
          )
        end
      end
    end
  end
end
