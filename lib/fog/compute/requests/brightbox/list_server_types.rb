module Fog
  module Brightbox
    class Compute
      class Real

        def list_server_types(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/1.0/server_types",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end