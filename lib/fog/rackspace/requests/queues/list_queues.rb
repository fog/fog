module Fog
  module Rackspace
    class Queues
      class Real
        def list_queues
          request(
            :expects => [200, 204],
            :method => 'GET',
            :path => 'queues'
          )
        end
      end
    end
  end
end
