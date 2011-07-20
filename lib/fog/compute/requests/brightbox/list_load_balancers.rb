module Fog
  module Compute
    class Brightbox
      class Real

        def list_load_balancers(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/1.0/load_balancers",
            :headers  => {"Content-Type" => "application/json"},
            :body     => MultiJson.encode(options)
          )
        end

      end
    end
  end
end