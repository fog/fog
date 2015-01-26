module Fog
  module Compute
    class Joyent
      class Mock
        def list_images
          res = Excon::Response.new
          res.status = 200
          res.body = self.data[:datasets].values
          res
        end
      end

      class Real
        def list_images
          request(
              :method => "GET",
              :path => "/#{@joyent_username}/images",
              :expects => 200,
              :idempotent => true
          )
        end
      end
    end
  end
end
