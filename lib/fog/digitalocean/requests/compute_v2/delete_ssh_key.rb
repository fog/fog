module Fog
  module Compute
    class DigitalOceanV2
      # noinspection RubyStringKeysInHashInspection
      class Real
        def delete_ssh_key(id)
          request(
            :expects => [204],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'DELETE',
            :path    => "/v2/account/keys/#{id}",
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def delete_ssh_key(id)
          self.data[:ssh_keys].select! do |key|
            key["id"] != id
          end

          response        = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
