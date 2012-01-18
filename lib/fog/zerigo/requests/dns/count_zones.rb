module Fog
  module DNS
    class Zerigo
      class Real

        require 'fog/zerigo/parsers/dns/count_zones'

        # Total number of zones hosted Zerigo for this account. It is the same value as provided 
        # in the X-Query-Count header in the list_zones API method
        #
        # ==== Returns
        # * response<~Excon::Response>: 
        #   * body<~Hash>
        #     * 'count'<~Integer> 
        #   * 'status'<~Integer> - 200 indicates success
        def count_zones
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Zerigo::CountZones.new,
            :path     => "/api/1.1/zones/count.xml"
          )
        end

      end

      class Mock # :nodoc:all
        def count_zones
          response = Excon::Response.new

          response.status = 200
          response.body = { 'count' => self.data[:zones].size }

          response
        end
      end
    end
  end
end
