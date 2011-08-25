module Fog
  module Compute
    class Brightbox
      class Real

        def create_load_balancer(options)
          request("post", "/1.0/load_balancers", [202], options)
        end

      end
    end
  end
end