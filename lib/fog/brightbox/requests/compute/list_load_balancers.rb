module Fog
  module Compute
    class Brightbox
      class Real

        def list_load_balancers
          request("get", "/1.0/load_balancers", [200])
        end

      end
    end
  end
end