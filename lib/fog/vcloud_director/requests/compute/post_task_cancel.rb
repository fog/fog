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
        #                                                                                         # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/2012-03-01/APIReference/ApiReference-query-DeleteNetworkInterface.html]
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
