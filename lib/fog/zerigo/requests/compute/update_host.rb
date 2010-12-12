module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/update_host'

        # Total number of zones hosted Zerigo for this account. It is the same value as provided 
        # in the X-Query-Count header in the list_zones API method
        #
        # ==== Returns
        # * response<~Excon::Response>: 
        #   * 'count'<~Integer> 
        def update_host( host_id, options = {})
          request(
            :expects  => 200,
            :method   => 'PUT',
            :parser   => Fog::Parsers::Zerigo::Compute::UpdateHost.new,
            :path     => "/api/1.1/hosts/#{host_id}.xml"
          )
        end

      end

      class Mock

        def update_host( host_id, options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
