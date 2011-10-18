module Fog
  module Compute
    class Brightbox
      class Real

        def remove_listeners_load_balancer(identifier, options)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/load_balancers/#{identifier}/remove_listeners", [202], options)
        end

      end
    end
  end
end