module Fog
  module Compute
    class OpenStack
      class Real

        def list_flavors_detail(options = {})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'flavors/detail.json',
            :query    => options
          )
        end

      end

      class Mock

        def list_flavors_detail(options = {})
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'flavors' => [
              { 'id' => '1', 'name' => '256 server', 'ram' => 256, 'disk' => 10, 'swap' => '1', 'vcpus' => 1, 'OS-FLV-EXT-DATA:ephemeral' => 1, 'links' => [] },
              { 'id' => '2', 'name' => '512 server', 'ram' => 512, 'disk' => 20, 'swap' => '1', 'vcpus' => 2, 'OS-FLV-EXT-DATA:ephemeral' => 1, 'links' => [] },
              { 'id' => '3', 'name' => '1GB server', 'ram' => 1024, 'disk' => 40, 'swap' => '2', 'vcpus' => 2, 'OS-FLV-EXT-DATA:ephemeral' => 1, 'links' => [] },
              { 'id' => '4', 'name' => '2GB server', 'ram' => 2048, 'disk' => 80, 'swap' => '4', 'vcpus' => 4, 'OS-FLV-EXT-DATA:ephemeral' => 1, 'links' => [] },
              { 'id' => '5', 'name' => '4GB server', 'ram' => 4096, 'disk' => 160, 'swap' => '8', 'vcpus' => 8, 'OS-FLV-EXT-DATA:ephemeral' => 1, 'links' => [] },
              { 'id' => '6', 'name' => '8GB server', 'ram' => 8192, 'disk' => 320, 'swap' => '16', 'vcpus' => 16, 'OS-FLV-EXT-DATA:ephemeral' => 1, 'links' => [] },
              { 'id' => '7', 'name' => '15.5GB server', 'ram' => 15872, 'disk' => 620, 'swap' => '32', 'vcpus' => 32, 'OS-FLV-EXT-DATA:ephemeral' => 1, 'links' => [] }
            ]
          }
          response
        end

      end
    end
  end
end
