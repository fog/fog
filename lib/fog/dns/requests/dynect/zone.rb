module Fog
  module Dynect
    class DNS
      class Real

        require 'fog/dns/parsers/dynect/zone'

        # GET information for the given zone
        # ==== Parameters
        # * name<~String> - zone name (ie example.com)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'zone_type'<~String>
        #     * 'serial_style'<~String>
        #     * 'serial'<~Integer>
        #     * 'zone'<~String>

        def zone(zone_name)
          request(
                  :parser   => Fog::Parsers::Dynect::DNS::Zone.new,
                  :expects  => 200,
                  :method   => "GET",
                  :path     => "Zone/#{zone_name}/",
                  )
        end
      end

      class Mock

        def zone(zone_name)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "zone" => "example.com",
            "serial" => 100,
            "zone_type" => "Primary",
            "serial_type" => "increment"
          }
          response
        end

      end

    end
  end
end
