module Fog
  module Stormondemand
    class Compute
      class Real

        def remove_balancer_node(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/network/loadbalancer/removenode",
            :headers  => {"Content-Type" => "application/json"},
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end