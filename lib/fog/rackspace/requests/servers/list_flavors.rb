unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List all flavors (IDs and names only)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - Id of the flavor
        #     * 'name'<~String> - Name of the flavor
        def list_flavors
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'flavors.json'
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def list_flavors
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end

end
