module Fog
  module Compute
    class Brightbox
      class Real
        # Get full details of the load balancer.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#load_balancer_get_load_balancer
        #
        def get_load_balancer(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/load_balancers/#{identifier}", [200])
        end
      end
    end
  end
end
