module Fog
  module Rackspace
    class Queues
      class Real

        # This operation returns queue statistics, including how many messages are in the queue, categorized by status.
        #
        # @param [String] queue_name Specifies the name of the queue.
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/GET_getQueueStats__version__queues__queue_name__stats_queue-operations-dle001.html
        def get_queue_stats(queue_name)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "queues/#{queue_name}/stats"
          )
        end
      end
    end
  end
end
