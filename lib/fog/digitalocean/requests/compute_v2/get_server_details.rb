module Fog
  module Compute
    class DigitalOceanV2
      class Real
        def get_server_details(server_id)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "/v2/droplets/#{server_id}"
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def get_server_details(_)
          response        = Excon::Response.new
          response.status = 200

          response.body = {
            'droplet' => {
              'id'           => 3164494,
              'name'         => 'example.com',
              'memory'       => 512,
              'vcpus'        => 1,
              'disk'         => 20,
              'locked'       => false,
              'status'       => 'active',
              'kernel'       => {
                'id'      => 2233,
                'name'    => 'Ubuntu 14.04 x64 vmlinuz-3.13.0-37-generic',
                'version' => '3.13.0-37-generic'
              },
              'created_at'   => '2014-11-14T16:36:31Z',
              'features'     => %w(ipv6 virtio),
              'backup_ids'   => [],
              'snapshot_ids' => [7938206],
              'image'        => {
                'id'            => 6918990,
                'name'          => '14.04 x64',
                'distribution'  => 'Ubuntu',
                'slug'          => 'ubuntu-14-04-x64',
                'public'        => true,
                'regions'       => %w(nyc1 ams1 sfo1 nyc2 ams2 sgp1 lon1 nyc3 ams3 nyc3),
                'created_at'    => '2014-10-17T20:24:33Z',
                'type'          => 'snapshot',
                'min_disk_size' => 20
              },
              'size'         => {},
              'size_slug'    => '512mb',
              'networks'     => {
                'v4' => [
                  {
                    'ip_address' => '104.131.186.241',
                    'netmask'    => '255.255.240.0',
                    'gateway'    => '104.131.176.1',
                    'type'       => 'public'
                  }
                ],
                'v6' => [
                  {
                    'ip_address' => '2604:A880:0800:0010:0000:0000:031D:2001',
                    'netmask'    => 64,
                    'gateway'    => '2604:A880:0800:0010:0000:0000:0000:0001',
                    'type'       => 'public'
                  }
                ]
              },
              'region'       => {
                'name'      => 'New York 3',
                'slug'      => 'nyc3',
                'sizes'     => %w(32gb 16gb 2gb 1gb 4gb 8gb 512mb 64gb 48gb),
                'features'  => %w(virtio private_networking backups ipv6 metadata),
                'available' => true
              }
            }
          }

          response
        end
      end
    end
  end
end
