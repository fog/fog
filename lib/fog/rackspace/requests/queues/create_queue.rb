module Fog
  module Rackspace
    class Queues
      class Real

        # This operation creates a new queue.
        # The body of the request is empty.
        #
        # @param [String] queue_name Specifies the name of the queue.
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/PUT_createQueue__version__queues__queue_name__queue-operations-dle001.html
        def create_queue(queue_name)
          request(
            :body => Fog::JSON.encode({}),
            :expects => 201,
            :method => 'PUT',
            :path => "queues/#{queue_name}"
          )
        end
      end
    end
  end
end
