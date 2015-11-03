module Fog
  module Compute
    class DigitalOceanV2
      class Real
        def list_ssh_keys
          request(
            :expects => [200],
            :method => 'GET',
            :path => 'v2/account/keys',
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def list_ssh_keys
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ssh_keys" => data[:ssh_keys],
            "links" => {},
            "meta" => {
              "total" => data[:ssh_keys].count
            }
          }
          response
        end
      end
    end
  end
end
