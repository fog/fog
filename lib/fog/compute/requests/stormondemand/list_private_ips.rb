module Fog
  module Stormondemand
    class Compute
      class Real

        def list_private_ips(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/network/private/get",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end