module Fog
  module Compute
    class Rackspace
      class Real

        # List all flavors
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
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'flavors/detail.json'
          )
        end

      end

      class Mock

        def list_flavors_detail
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'flavors' => [
              { 'name' => '256 server',    'id' => 1, 'ram' => 256,    'disk' => 10   },
              { 'name' => '512 server',    'id' => 2, 'ram' => 512,    'disk' => 20   },
              { 'name' => '1GB server',    'id' => 3, 'ram' => 1024,   'disk' => 40   },
              { 'name' => '2GB server',    'id' => 4, 'ram' => 2048,   'disk' => 80   },
              { 'name' => '4GB server',    'id' => 5, 'ram' => 4096,   'disk' => 160  },
              { 'name' => '8GB server',    'id' => 6, 'ram' => 8192,   'disk' => 320  },
              { 'name' => '15.5GB server', 'id' => 7, 'ram' => 15872,  'disk' => 620  }
            ]
          }
          response
        end

      end
    end
  end
end
