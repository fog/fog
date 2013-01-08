module Fog
  module Rackspace
    class BlockStorage
      class Real
        def get_volume_type(volume_type_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "types/#{volume_type_id}"
          )
        end
      end
    end
  end
end
