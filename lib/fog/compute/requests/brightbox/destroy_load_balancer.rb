module Fog
  module Compute
    class Brightbox
      class Real

        def destroy_load_balancer(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/load_balancers/#{identifier}", [202])
        end

      end
    end
  end
end