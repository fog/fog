module Fog
  module Dynect
    class DNS
      class Real

        require 'fog/dns/parsers/dynect/zones'

        def zones
          request(
                  :parser   => Fog::Parsers::Dynect::DNS::Zones.new,
                  :expects  => 200,
                  :method   => "GET",
                  :path     => "Zone",
                  )
        end
      end

      class Mock

        def zones
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "zones" => ["example.com"]
          }
          response
        end

      end

    end
  end
end
