module Fog
  module Compute
    class DigitalOceanV2
      class Real
        def get_ssh_key(key_id)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "/v2/account/keys/#{key_id}"
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def get_ssh_key(_)
          response        = Excon::Response.new
          response.status = 200

          response.body = {
            'ssh_key' => {
              'id'          => 512190,
              'fingerprint' => '3b:16:bf:e4:8b:00:8b:b8:59:8c:a9:d3:f0:19:45:fa',
              'public_key'  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAQQDDHr/jh2Jy4yALcK4JyWbVkPRaWmhck3IgCoeOO3z1e2dBowLh64QAM+Qb72pxekALga2oi4GvT+TlWNhzPH4V example',
              'name'        => 'My SSH Public Key'
            }
          }

          response
        end
      end
    end
  end
end
