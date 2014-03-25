module Fog
  module Network
    class OpenStack

      class Real
        def list_subnets(filters = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'subnets',
            :query   => filters
          )
        end
      end

      class Mock
        def list_subnets(filters = {})
          Excon::Response.new(
            :body   => { 'subnets' => self.data[:subnets].values },
            :status => 200
          )
        end
      end

    end
  end
end
