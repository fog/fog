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

      class Mock

        def create_load_balancer(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end