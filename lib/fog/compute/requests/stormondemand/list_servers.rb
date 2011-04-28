module Fog
  module Stormondemand
    class Compute
      class Real

        def list_servers(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/storm/server/list",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end