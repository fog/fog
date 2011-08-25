module Fog
  module Compute
    class Brightbox
      class Real

        def update_load_balancer(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          request("put", "/1.0/load_balancers/#{identifier}", [202], options)
        end

      end
    end
  end
end