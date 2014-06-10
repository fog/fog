module Fog
  module Rackspace
    class Queues
      class Real
        # This operation immediately deletes a queue and all of its existing messages.
        #
        # @param [String] queue_name Specifies the name of the queue.
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/DELETE_deleteQueue__version__queues__queue_name__queue-operations-dle001.html
        def delete_queue(queue_name)
          request(
            :expects => 204,
            :method => 'DELETE',
            :path => "queues/#{queue_name}"
          )
        end
      end

      class Mock
        def delete_queue(queue_name)
          data.delete(queue_name)
          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
