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
            :expects => [201],
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
          response.status = 201

          data[:ssh_keys] << {
            "id" => Fog::Mock.random_numbers(6).to_i,
            "fingerprint" => (["00"] * 16).join(':'),
            "public_key" => public_key,
            "name" => name
          }

          response.body ={
            'ssh_key' => data[:ssh_keys].last
          }

          response
        end
      end
    end
  end
end
