module Fog
  module Dynect
    class DNS
      class Real

        # require 'fog/dns/parsers/dynect/session'

        def zone
          request(
                  :expects  => 200,
                  :method   => "GET",
                  :path     => "Zone",
                  )
        end
      end

      class Mock

        def zone
          response = Excon::Response.new
          response.status = 200
          response.body = {
          }
          response
        end

      end

    end
  end
end
