module Fog
  module DNS
    class Zerigo
      class Real
        require 'fog/zerigo/parsers/dns/count_hosts'

        # total number of hosts available for the specified zone. It is the same value as provided
        # in the X-Query-Count header in the list_hosts API method
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        #     * 'count'<~Integer>
        #   * 'status'<~Integer> - 200 indicates success
        def count_hosts(zone_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Zerigo::CountHosts.new,
            :path     => "/api/1.1/zones/#{zone_id}/hosts/count.xml"
          )
        end
      end

      class Mock # :nodoc:all
        def count_hosts(zone_id)
          zone = find_by_zone_id(zone_id)

          response = Excon::Response.new

          if zone
            response.status = 200
            response.body = {
              'count' => zone['hosts'].size
            }
          else
            response.status = 404
          end

          response
        end
      end
    end
  end
end
