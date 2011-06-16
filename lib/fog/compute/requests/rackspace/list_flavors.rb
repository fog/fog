module Fog
  module Compute
    class Rackspace
      class Real

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

      class Mock

        def list_flavors
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'flavors' => [
              { 'name' => '256 server',    'id' => 1 },
              { 'name' => '512 server',    'id' => 2 },
              { 'name' => '1GB server',    'id' => 3 },
              { 'name' => '2GB server',    'id' => 4 },
              { 'name' => '4GB server',    'id' => 5 },
              { 'name' => '8GB server',    'id' => 6 },
              { 'name' => '15.5GB server', 'id' => 7 }
            ]
          }
          response
        end

      end
    end
  end
end
