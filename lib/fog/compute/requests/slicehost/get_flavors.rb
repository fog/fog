module Fog
  module Slicehost
    class Compute
      class Real

        require 'fog/compute/parsers/slicehost/get_flavors'

        # Get list of flavors
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'id'<~Integer> - Id of the flavor
        #     * 'name'<~String> - Name of the flavor
        #     * 'price'<~Integer> - Price in cents
        #     * 'ram'<~Integer> - Amount of ram for the flavor
        def get_flavors
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Slicehost::Compute::GetFlavors.new,
            :path     => 'flavors.xml'
          )
        end

      end
    end
  end
end
