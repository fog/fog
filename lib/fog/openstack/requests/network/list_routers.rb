module Fog
  module Network
    class OpenStack

      class Real
        def list_routers(filters = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'routers',
            :query   => filters
          )
        end
      end

      class Mock
        def list_routers(filters = {})
          Excon::Response.new(
            :body   => { 'routers' => self.data[:routers].values },
            :status => 200
          )
        end
      end

    end
  end
end
