module Fog
  module Compute
    class Brightbox
      class Real
        # Destroy the LoadBalancer
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#load_balancer_destroy_load_balancer
        #
        def destroy_load_balancer(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/load_balancers/#{identifier}", [202])
        end

      end
    end
  end
end
