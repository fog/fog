module Fog
  module Compute
    class Slicehost
      class Real

        require 'fog/slicehost/parsers/compute/get_flavors'

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
            :parser   => Fog::Parsers::Compute::Slicehost::GetFlavors.new,
            :path     => 'flavors.xml'
          )
        end

      end
    end
  end
end
