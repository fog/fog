module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a task.
        #
        # @param [String] id The object identifier of the task.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Task.html
        #   vCloud API Documentation
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
          response = Excon::Response.new

          unless valid_uuid?(id)
            response.status = 400
            raise Excon::Error.status_error({:expects => 200}, response)
          end
          unless task = data[:tasks][id]
            response.status = 403
            raise Excon::Error.status_error({:expects => 200}, response)
          end

          Fog::Mock.not_implemented
          task.is_used_here # avoid warning from syntax checker
        end
      end
    end
  end
end
