module Fog
  module Compute
    class Brightbox
      class Real
        # Remove a number of nodes from the load balancer
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Array] :nodes Array of Node parameters
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#load_balancer_remove_nodes_load_balancer
        #
        def remove_nodes_load_balancer(identifier, options)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/load_balancers/#{identifier}/remove_nodes", [202], options)
        end

      end
    end
  end
end
