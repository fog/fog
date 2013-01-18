module Fog
  module Compute
    class Joyent
      class Mock

        def get_key(keyid)
          if key = self.data[:keys][keyid]
            response = Excon::Response.new
            response.status = 200
            response.body = key
            response
          else
            raise Excon::Errors::NotFound
          end
        end
      end

      class Real
        def get_key(keyid)
          request(
            :method => "GET",
            :path => "/my/keys/#{keyid}",
            :expects => 200
          )
        end
      end
    end
  end
end
