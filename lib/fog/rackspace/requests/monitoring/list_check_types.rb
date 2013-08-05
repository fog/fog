module Fog
  module Rackspace
    class Monitoring
      class Real

        def list_check_types
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "check_types"
          )
        end

      end
    end
  end
end
