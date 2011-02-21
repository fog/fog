module Fog
  module Zerigo
    class DNS
      class Real

        require 'fog/dns/parsers/zerigo/count_zones'

        # Total number of zones hosted Zerigo for this account. It is the same value as provided 
        # in the X-Query-Count header in the list_zones API method
        #
        # ==== Returns
        # * response<~Excon::Response>: 
        #   * body<~Hash>
        #     * 'count'<~Integer> 
        #   * 'status'<~Integer> - 200 indicates success
        def count_zones()
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Zerigo::DNS::CountZones.new,
            :path     => "/api/1.1/zones/count.xml"
          )
        end

      end
    end
  end
end
