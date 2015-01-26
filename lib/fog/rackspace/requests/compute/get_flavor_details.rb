module Fog
  module Compute
    class Rackspace
      class Real
        # Get details for flavor by id
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - Id of the flavor
        #     * 'name'<~String> - Name of the flavor
        #     * 'ram'<~Integer> - Amount of ram for the flavor
        #     * 'disk'<~Integer> - Amount of diskspace for the flavor
        def get_flavor_details(flavor_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "flavors/#{flavor_id}.json"
          )
        end
      end

      class Mock
        def get_flavor_details(flavor_id)
          response = Excon::Response.new
          flavor = {
            1 => { 'name' => '256 server',    'ram' => 256,    'disk' => 10   },
            2 => { 'name' => '512 server',    'ram' => 512,    'disk' => 20   },
            3 => { 'name' => '1GB server',    'ram' => 1024,   'disk' => 40   },
            4 => { 'name' => '2GB server',    'ram' => 2048,   'disk' => 80   },
            5 => { 'name' => '4GB server',    'ram' => 4096,   'disk' => 160  },
            6 => { 'name' => '8GB server',    'ram' => 8192,   'disk' => 320  },
            7 => { 'name' => '15.5GB server', 'ram' => 15872,  'disk' => 620  }
          }[flavor_id]
          if flavor
            response.status = 200
            response.body = {
              'flavor' => flavor
            }
            response
          else
            raise Fog::Compute::Rackspace::NotFound
          end
        end
      end
    end
  end
end
