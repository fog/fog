module Fog
  module Rackspace
    class BlockStorage
      class Real
        def list_volumes
          request(
            :expects => [200],
            :method => 'GET',
            :path => 'volumes'
          )
        end
      end
    end
  end
end
