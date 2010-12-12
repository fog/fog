module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/count_zones'

        # Total number of zones available. It is the same value as provided in the X-Query-Count 
        # header in the list_zones API method
        #
        # ==== Returns
        # * response<~Excon::Response>: 
        #   * 'count'<~Integer> 
        def count_zones()
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Zerigo::Compute::CountZones.new,
            :path     => "/api/1.1./zones/count.xml"
          )
        end

      end

      class Mock

        def count_zones()
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
