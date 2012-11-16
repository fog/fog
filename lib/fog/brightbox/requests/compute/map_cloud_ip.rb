module Fog
  module Compute
    class Brightbox
      class Real
        # Maps (or points) a cloud IP address at a server's interface or a load balancer to allow them to respond to public requests.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :destination The ID of an Interface or LoadBalancer to map the Cloud IP against
        #
        # @return [Hash, nil] The JSON response parsed to a Hash or nil if no options passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#cloud_ip_map_cloud_ip
        #
        def map_cloud_ip(identifier, options)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/cloud_ips/#{identifier}/map", [202], options)
        end

      end
    end
  end
end
