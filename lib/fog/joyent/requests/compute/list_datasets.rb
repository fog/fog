module Fog
  module Compute
    class Joyent
      class Mock
        def list_datasets
          res = Excon::Response.new
          res.status = 200
          res.body = self.data[:datasets].values
          res
        end
      end

      class Real
        def list_datasets
          request(
            :method => "GET",
            :path => "/my/datasets",
            :idempotent => true
          )
        end
      end
    end
  end
end
