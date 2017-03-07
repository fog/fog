module Fog
  module Compute
    class DigitalOceanV2
      # noinspection RubyStringKeysInHashInspection
      class Real

        def create_server(name,
                          size,
                          image,
                          region,
                          options = {})

          create_options = {
            :name   => name,
            :region => region,
            :size   => size,
            :image  => image,
          }

          [:backups, :ipv6, :private_networking].each do |opt|
            create_options[opt] = !!options[opt] if options[opt]
          end

          [:user_data, :ssh_keys].each do |opt|
            create_options[opt] = options[opt] if options[opt]
          end

          encoded_body = Fog::JSON.encode(create_options)

          request(
            :expects => [202],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'POST',
            :path    => '/v2/droplets',
            :body    => encoded_body,
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def create_server(name,
                          size,
                          image,
                          region,
                          options = {})

          response        = Excon::Response.new
          response.status = 202

          response.body = {
            'droplet' => {
              'id'           => 3164494,
              'name'         => name,
              'memory'       => 512,
              'vcpus'        => 1,
              'disk'         => 20,
              'locked'       => true,
              'status'       => 'new',
              'kernel'       => {
                'id'      => 2233,
                'name'    => 'Ubuntu 14.04 x64 vmlinuz-3.13.0-37-generic',
                'version' => '3.13.0-37-generic'
              },
              'created_at'   => '2014-11-14T16:36:31Z',
              'features'     => %w(virtio),
              'backup_ids'   => [],
              'snapshot_ids' => [],
              'image'        => {},
              'size'         => {},
              'size_slug'    => '512mb',
              'networks'     => {},
              'region'       => {}
            },
            'links'   => {
              'actions' => [
                {
                  'id'   => 36805096,
                  'rel'  => "create",
                  'href' => "https://api.digitalocean.com/v2/actions/36805096"
                }
              ]
            }
          }

          response
        end
      end
    end
  end
end
