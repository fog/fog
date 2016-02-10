module Fog
  module Compute
    class OpenStack
      class Real
        def list_snapshots_detail(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'os-snapshots/detail',
            :query    => options
          )
        end
      end

      class Mock
        def list_snapshots_detail(options = {})
          response = Excon::Response.new
          response.status = 200
          snapshots = self.data[:snapshots].values
          response.body = { 'snapshots' => snapshots }
          response
        end
      end
    end
  end
end
