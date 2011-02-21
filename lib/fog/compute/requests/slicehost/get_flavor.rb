module Fog
  module Slicehost
    class Compute
      class Real

        require 'fog/compute/parsers/slicehost/get_flavor'

        # Get details of a flavor
        #
        # ==== Parameters
        # * flavor_id<~Integer> - Id of flavor to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'id'<~Integer> - Id of the flavor
        #     * 'name'<~String> - Name of the flavor
        #     * 'price'<~Integer> - Price in cents
        #     * 'ram'<~Integer> - Amount of ram for the flavor
        def get_flavor(flavor_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Slicehost::Compute::GetFlavor.new,
            :path     => "flavors/#{flavor_id}.xml"
          )
        end

      end
    end
  end
end
