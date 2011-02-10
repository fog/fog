module Fog
  module Brightbox
    class Compute
      class Real

        def create_load_balancer(options = {})
          request(
            :expects  => [202],
            :method   => 'POST',
            :path     => "/1.0/load_balancers",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end