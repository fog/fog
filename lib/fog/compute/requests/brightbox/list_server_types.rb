module Fog
  module Compute
    class Brightbox
      class Real

        def list_server_types(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/1.0/server_types",
            :headers  => {"Content-Type" => "application/json"},
            :body     => MultiJson.encode(options)
          )
        end

      end
    end
  end
end