module Fog
  module Rackspace
    class Queues
      class Real
        # This operation verifies whether the specified queue exists.
        #
        # @param [String] queue_name Specifies the name of the queue.
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/GET_checkQueueExists__version__queues__queue_name__queue-operations-dle001.html
        def get_queue(queue_name)
          request(
            :expects => [200, 204],
            :method => 'GET',
            :path => "queues/#{queue_name}"
          )
        end
      end

      class Mock
        def get_queue(queue_name)
          if mock_queue(queue_name).nil?
            raise NotFound.new
          else
            response = Excon::Response.new
            response.status = 204
            response
          end
        end
      end
    end
  end
end
