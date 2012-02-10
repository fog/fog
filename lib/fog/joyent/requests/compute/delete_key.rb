module Fog
  module Compute
    class Joyent

      class Mock
        def delete_key(keyname)
          if self.data[:keys].delete(keyname)
            response = Excon::Response.new
            response.status = 200
            response
          else
            raise Excon::Errors::NotFound, "Not Found"
          end
        end
      end

      class Real
        def delete_key(keyname)
          request(
            :method => "DELETE",
            :path => "/my/keys/#{name}",
            :expects => 200
          )
        end
      end # Real

    end
  end
end
