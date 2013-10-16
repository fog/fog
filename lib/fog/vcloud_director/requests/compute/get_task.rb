module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a task.
        #
        # @param [String] id The object identifier of the task.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Task.html
        # @since vCloud API version 0.9
        def get_task(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "task/#{id}"
          )
        end
      end

      class Mock
        def get_task(id)
          unless task = data[:tasks][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Fog::Mock.not_implemented
          task.is_used_here # avoid warning from syntax checker
        end
      end
    end
  end
end
