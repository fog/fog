module Fog
  module Compute
    class RackspaceV2
      class Real
        def get_flavor(flavor_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "flavors/#{flavor_id}"
          )
        end
      end
    end
  end
end
