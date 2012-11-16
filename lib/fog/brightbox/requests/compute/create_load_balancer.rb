module Fog
  module Compute
    class Brightbox
      class Real
        # Create a new load balancer for the account.
        #
        # @param [Hash] options
        # @option options [String] :name Editable label
        # @option options [Array] :nodes Array of Node parameters
        # @option options [String] :policy Method of Load balancing to use
        # @option options [Array] :listeners What port to listen on, port to pass through to and protocol (tcp, http or http+ws) of listener. Timeout is optional and specified in milliseconds (default is 50000).
        # @option options [String] :healthcheck Healthcheck options - only "port" and "type" required
        #
        # @return [Hash, nil] The JSON response parsed to a Hash or nil if no options passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#load_balancer_create_load_balancer
        #
        def create_load_balancer(options)
          request("post", "/1.0/load_balancers", [202], options)
        end

      end
    end
  end
end
