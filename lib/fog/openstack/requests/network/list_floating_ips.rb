module Fog
  module Network
    class OpenStack

      class Real
        def list_floating_ips(filters = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'floatingips',
            :query   => filters
          )
        end
      end

      class Mock
        def list_floating_ips(filters = {})
          Excon::Response.new(
            :body   => { 'floating_ips' => self.data[:floating_ips].values },
            :status => 200
          )
        end
      end

    end
  end
end
