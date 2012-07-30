module Fog
  module Compute
    class RackspaceV2
      class Real
        def list_servers
          request(
            :expects => [200, 203, 300],
            :method => 'GET',
            :path => 'servers'
          )
        end
      end
    end
  end
end
