module Fog
  module Compute
    class Joyent
      class Mock
        def list_networks(options={})
          res = Excon::Response.new
          res.status = 200
          res.body = self.data[:networks].values
          res
        end
      end

      class Real
        def list_networks(options={})
          request(
            :path => "/my/networks",
            :method => "GET",
            :query => options,
            :expects => 200,
            :idempotent => true
          )
        end
      end
    end
  end
end
