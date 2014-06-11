module Fog
  module Compute
    class Joyent
      class Mock
        def list_machines(options={})
          res = Excon::Response.new
          res.status = 200
          res.body = self.data[:machines].values
          res
        end
      end

      class Real
        def list_machines(options={})
          request(
            :path => "/my/machines",
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
