module Fog
  module Rackspace
    class BlockStorage
      class Real
        def get_volume(volume_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "volumes/#{volume_id}"
          )
        end
      end
    end
  end
end
