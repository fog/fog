module Fog
  module Compute
    class OpenStack
      class Real
        def list_volumes(detailed=true)
          path = detailed ? 'os-volumes/detail' : 'os-volumes'
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => path
          )
        end
      end

      class Mock
        def list_volumes(detailed=true)
          Excon::Response.new(
            :body   => { 'volumes' => self.data[:volumes].values },
            :status => 200
          )
        end
      end
    end
  end
end
