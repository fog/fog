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
        # @since vCloud API version 0.9
        def get_task(task_id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "task/#{task_id}"
          )
        end
      end

      class Mock
        def get_task(task_id)
          response = Excon::Response.new

          unless valid_uuid?(task_id)
            response.status = 400
            raise Excon::Error.status_error({:expects => 200}, response)
          end
          unless task = data[:tasks][task_id]
            response.status = 403
            raise Excon::Error.status_error({:expects => 200}, response)
          end

          Fog::Mock.not_implemented
        end
      end
    end
  end
end
