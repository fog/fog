module Fog
  module Rackspace
    class Monitoring
      class Real

        def list_entities(options={})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'entities',
            :query    => options
          )
        end

      end
    end
  end
end

