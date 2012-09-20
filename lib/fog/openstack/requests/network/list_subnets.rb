module Fog
  module Network
    class OpenStack

      class Real
        def list_subnets
          request(
            :expects => 200,
            :method => 'GET',
            :path   => 'subnets'
          )
        end
      end

      class Mock
        def list_subnets
          Excon::Response.new(
            :body   => { 'subnets' => self.data[:subnets].values },
            :status => 200
          )
        end
      end

    end
  end
end