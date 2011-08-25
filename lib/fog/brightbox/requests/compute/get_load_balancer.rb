module Fog
  module Compute
    class Brightbox
      class Real

        def get_load_balancer(identifier)
          return nil if identifier.nil? || identifier == ""
          request("get", "/1.0/load_balancers/#{identifier}", [200])
        end

      end
    end
  end
end