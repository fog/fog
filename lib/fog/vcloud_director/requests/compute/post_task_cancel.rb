module Fog
  module Compute
    class VcloudDirector
      class Real

        # Cancel a task.
        #
        # ==== Parameters
        # * task_id<~String> - The ID of the task you want to cancel.
        #
        # === Returns
        # * response<~Excon::Response>
        #
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
