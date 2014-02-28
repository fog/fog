module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of load balancers owned by the account.
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#load_balancer_list_load_balancers
        #
        def list_load_balancers
          wrapped_request("get", "/1.0/load_balancers", [200])
        end

      end
    end
  end
end
