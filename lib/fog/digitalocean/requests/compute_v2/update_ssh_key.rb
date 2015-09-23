module Fog
  module Compute
    class DigitalOceanV2
      # noinspection RubyStringKeysInHashInspection
      class Real

        def update_ssh_key(key_id, name)
          update_options = {
            :name       => name,
          }

          encoded_body = Fog::JSON.encode(update_options)

          request(
            :expects => [200],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'PUT',
            :path    => "/v2/account/keys/#{key_id}",
            :body    => encoded_body,
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def update_ssh_key(key_id, name)
          response        = Excon::Response.new
          response.status = 200

          response.body ={
            'ssh_key' => {
              'id'          => 512190,
              'fingerprint' => "3b:16:bf:e4:8b:00:8b:b8:59:8c:a9:d3:f0:19:45:fa",
              'public_key'  => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAQQDDHr/jh2Jy4yALcK4JyWbVkPRaWmhck3IgCoeOO3z1e2dBowLh64QAM+Qb72pxekALga2oi4GvT+TlWNhzPH4V example",
              'name'        => "My SSH Public Key"
            }
          }

          response
        end
      end
    end
  end
end
