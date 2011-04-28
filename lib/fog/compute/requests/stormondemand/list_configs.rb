module Fog
  module Stormondemand
    class Compute
      class Real

        def list_configs(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/storm/config/list",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end