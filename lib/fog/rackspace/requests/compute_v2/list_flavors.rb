module Fog
  module Compute
    class RackspaceV2
      class Real
        def list_flavors
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'flavors'
          )
        end
      end
    end
  end
end
