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

      class Mock
        def post_cancel_task(id)
          unless task = data[:tasks][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'No access to entity "com.vmware.vcloud.entity.task:%s"' % id
            )
          end

          # @note Tasks don't actually get cancelled (confirmed VCloud Director
          #   bug) so we'll emulate that. Set the flag and we're done!
          task[:cancel_requested] = true

          Excon::Response.new(
            :status => 204
          )
        end
      end
    end
  end
end
