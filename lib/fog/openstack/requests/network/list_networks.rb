module Fog
  module Network
    class OpenStack

      class Real
        def list_networks
          request(
            :expects => 200,
            :method => 'GET',
            :path   => 'networks'
          )
        end
      end

      class Mock
        def list_networks
          Excon::Response.new(
            :body   => { 'networks' => self.data[:networks].values },
            :status => 200
          )
        end
      end

    end
  end
end