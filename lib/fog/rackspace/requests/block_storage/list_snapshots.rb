module Fog
  module Rackspace
    class BlockStorage
      class Real
        def list_snapshots
          request(
            :expects => [200],
            :method => 'GET',
            :path => 'snapshots'
          )
        end
      end
    end
  end
end
