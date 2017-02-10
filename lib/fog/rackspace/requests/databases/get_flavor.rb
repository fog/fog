module Fog
  module Rackspace
    class Databases
      class Real
        def get_flavor(flavor_id)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "flavors/#{flavor_id}"
          )
        end
      end
    end
  end
end
