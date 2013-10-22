require 'fog/core/collection'
require 'fog/rackspace/models/queues/queue'

module Fog
  module Rackspace
    class Queues
      class Queues < Fog::Collection

        model Fog::Rackspace::Queues::Queue

        def all
          response = service.list_queues
          if service.list_queues.status == 204
            data = []
          else
            data = service.list_queues.body['queues']
          end
          load(data)
        end

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
