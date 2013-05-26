module Fog
  module Volume
    class OpenStack

      class Real
        def list_volumes(detailed = true, filters = {})
          path = detailed ? 'volumes/detail' : 'volumes'
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => path,
            :query   => filters
          )
        end
      end

      class Mock
        def list_volumes(detailed = true, filters = {})
          Excon::Response.new(
            :body   => { 'volumes' => self.data[:volumes].values },
            :status => 200
          )
        end
      end

    end
  end
end