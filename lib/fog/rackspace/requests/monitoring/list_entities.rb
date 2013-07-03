module Fog
  module Rackspace
    class Monitoring
      class Real

        def list_entities
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'entities'
          )
        end

      end
    end
  end
end

