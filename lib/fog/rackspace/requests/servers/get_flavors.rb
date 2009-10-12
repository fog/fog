unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List all images (IDs and names only)
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - Id of the flavor
        #     * 'name'<~String> - Name of the flavor
        #     * 'ram'<~Integer> - Amount of ram for the flavor
        #     * 'disk'<~Integer> - Amount of diskspace for the flavor
        def get_flavors
          request(
            :method => 'GET',
            :path   => 'flavors'
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def get_flavors
        end

      end
    end
  end

end
