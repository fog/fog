module Fog
  module Compute
    class DigitalOceanV2
      class Real
        def list_ssh_keys(filters = {})
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "v2/account/keys",
            :query   => filters
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def list_ssh_keys(filters = {})
          response        = Excon::Response.new
          response.status = 200
          response.body   = {
            "ssh_keys" => data[:ssh_keys] ||
              [
                {
                  "id" => 512189,
                  "fingerprint" => "3b:16:bf:e4:8b:00:8b:b8:59:8c:a9:d3:f0:19:45:fa",
                  "public_key" => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAQQDDHr/jh2Jy4yALcK4JyWbVkPRaWmhck3IgCoeOO3z1e2dBowLh64QAM+Qb72pxekALga2oi4GvT+TlWNhzPH4V example",
                  "name" => "My SSH Public Key"
                }
              ],
            "links" => {
            },
            "meta" => {
              "total" => data[:ssh_keys].count || 1
            }
          }
          response
        end
      end
    end
  end
end
