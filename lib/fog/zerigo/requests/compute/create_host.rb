module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/create_host'

        # Total number of zones hosted Zerigo for this account. It is the same value as provided 
        # in the X-Query-Count header in the list_zones API method
        #
        # ==== Returns
        # * response<~Excon::Response>: 
        #   * 'count'<~Integer> 
        def create_host( zone_id, hostname, host-type, data, options)
          request(
            :expects  => 200,
            :method   => 'POST',
            :parser   => Fog::Parsers::Zerigo::Compute::CreateHost.new,
            :path     => "/api/1.1/zones/#{zone_id}/hosts.xml"
          )
        end

      end

      class Mock

        def create_host( host_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
