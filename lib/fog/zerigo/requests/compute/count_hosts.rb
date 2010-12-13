module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/count_hosts'

        # total number of hosts available for the specified zone. It is the same value as provided 
        # in the X-Query-Count header in the list_hosts API method
        #
        # ==== Returns
        # * response<~Excon::Response>: 
        #   * 'count'<~Integer> 
        def count_hosts( zone_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Zerigo::Compute::CountHosts.new,
            :path     => "/api/1.1/zones/#{zone_id}/hosts/count.xml"
          )
        end

      end

      class Mock

        def count_hosts( zone_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
