module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a task.
        #
        # @param [String] task_id ID of the task to retrieve.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Task.html
        #   vCloud API Documentation
        def get_task(task_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::ToHashDocument.new,
            :path    => "task/#{task_id}"
          )
        end
      end
    end
  end
end
