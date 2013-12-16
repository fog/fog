module Fog
  module Compute
    class Joyent

      class Mock
        def get_image(id)
          if ds = self.data[:datasets][id]
            res = Excon::Response.new
            res.status = 200
            res.body = ds
          else
            raise Excon::Errors::NotFound
          end
        end
      end

      class Real
        def get_image(id)
          request(
              :method => "GET",
              :path => "/#{@joyent_username}/images/#{id}",
              :expects => 200
          )
        end
      end

    end
  end
end
