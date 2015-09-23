module Fog
  module Compute
    class DigitalOceanV2
      # noinspection RubyStringKeysInHashInspection
      class Real
        def delete_server(server_id)
          request(
            :expects         => [204],
            :headers         => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method          => 'DELETE',
            :path            => "/v2/droplets/#{server_id}",
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def delete_server(_)
          response        = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
