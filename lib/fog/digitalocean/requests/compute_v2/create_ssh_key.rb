module Fog
  module Compute
    class DigitalOceanV2
      # noinspection RubyStringKeysInHashInspection
      class Real

        def create_ssh_key(name, public_key)
          create_options = {
            :name       => name,
            :public_key => public_key,
          }

          encoded_body = Fog::JSON.encode(create_options)

          request(
            :expects => [202],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'POST',
            :path    => '/v2/account/keys',
            :body    => encoded_body,
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def create_ssh_key(name, public_key)
          response        = Excon::Response.new
          response.status = 202

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
