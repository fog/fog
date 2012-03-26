module Fog
  module Compute
    class Joyent

      class Mock
        def delete_key(keyname)
          if self.data[:keys].delete(keyname)
            response = Excon::Response.new
            response.status = 204
            response
          else
            raise Excon::Errors::NotFound, "Not Found"
          end
        end
      end

      class Real
        def delete_key(name)
          request(
            :method => "DELETE",
            :path => "/my/keys/#{name}",
            :expects => 204
          )
        end
      end # Real

    end
  end
end
