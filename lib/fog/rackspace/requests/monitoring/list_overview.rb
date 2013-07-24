module Fog
  module Rackspace
    class Monitoring
      class Real

        def list_overview(options={})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "views/overview",
            :query    => options
          )
        end

      end
    end
  end
end

