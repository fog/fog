require 'fog/core/collection'
require 'fog/rackspace/models/queues/queue'

module Fog
  module Rackspace
    class Queues
      class Queues < Fog::Collection
        model Fog::Rackspace::Queues::Queue

        # Returns list of queues
        #
        # @return [Fog::Rackspace::Queues::Queues] Retrieves a collection of queues.
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/GET_listQueues__version__queues_.html
        def all
          response = service.list_queues
          if service.list_queues.status == 204
            data = []
          else
            data = service.list_queues.body['queues']
          end
          load(data)
        end

        # This operation queries the specified queue.
        #
        # @param [String] queue_name Specifies the queue name
        # @return [Fog::Rackspace::Queues::Queue] Returns a queue
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/GET_checkQueueExists__version__queues__queue_name__queue-operations-dle001.html
        def get(queue_name)
          #204 no content is returned on success.  That's why no data is passed
          # from the GET to the constructor.
          service.get_queue(queue_name)
          new({:name => queue_name})
        rescue Fog::Rackspace::Queues::NotFound
          nil
        end
      end
    end
  end
end
