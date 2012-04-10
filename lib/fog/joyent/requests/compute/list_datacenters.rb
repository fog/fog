module Fog
  module Compute
    class Joyent

      class Real
        def list_datacenters
          request(
            :expects => 200,
            :method => :'GET',
            :path => '/my/datacenters'
          )
        end
      end # Real

    end
  end
end
