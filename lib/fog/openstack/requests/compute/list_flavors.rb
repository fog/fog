module Fog
  module Compute
    class OpenStack
      class Real

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
              { 'name' => '256 server', 'id' => '1', 'links' => [] },
              { 'name' => '512 server', 'id' => '2', 'links' => [] },
              { 'name' => '1GB server', 'id' => '3', 'links' => [] },
              { 'name' => '2GB server', 'id' => '4', 'links' => [] },
              { 'name' => '4GB server', 'id' => '5', 'links' => [] },
              { 'name' => '8GB server', 'id' => '6', 'links' => [] },
              { 'name' => '15.5GB server', 'id' => '7', 'links' => [] }
            ]
          }
          response
        end

      end
    end
  end
end
