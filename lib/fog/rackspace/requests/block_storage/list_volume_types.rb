module Fog
  module Rackspace
    class BlockStorage
      class Real
        def list_volume_types
          request(
            :expects => [200],
            :method => 'GET',
            :path => 'types'
          )
        end
      end
    end
  end
end
