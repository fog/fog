module Fog
  module Network
    class OpenStack

      class Real
        def list_floatingips(filters = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'floatingips',
            :query   => filters
          )
        end
      end

      class Mock
        def list_floatingips(filters = {})
          Excon::Response.new(
            :body   => { 'floatingips' => self.data[:floatingips].values },
            :status => 200
          )
        end
      end

    end
  end
end
