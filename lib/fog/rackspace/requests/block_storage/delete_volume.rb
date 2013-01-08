module Fog
  module Rackspace
    class BlockStorage
      class Real
        def delete_volume(volume_id)
          request(
            :expects => [202],
            :method => 'DELETE',
            :path => "volumes/#{volume_id}"
          )
        end
      end
    end
  end
end
