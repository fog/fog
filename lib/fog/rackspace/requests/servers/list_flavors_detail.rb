unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List all images (IDs and names only)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - Id of the flavor
        #     * 'name'<~String> - Name of the flavor
        #     * 'ram'<~Integer> - Amount of ram for the flavor
        #     * 'disk'<~Integer> - Amount of diskspace for the flavor
        def list_flavors_detail
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'flavors/detail.json'
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def list_flavors_detail
        end

      end
    end
  end

end
