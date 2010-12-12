module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/get_hosts'

        # Total number of zones hosted Zerigo for this account. It is the same value as provided 
        # in the X-Query-Count header in the list_zones API method
        #
        # ==== Returns
        # * response<~Excon::Response>: 
        #   * 'count'<~Integer> 
        def get_host( host_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Zerigo::Compute::GetZone.new,
            :path     => "/api/1.1/hosts/#{host_id}.xml"
          )
        end

      end

      class Mock

        def get_host( host_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
