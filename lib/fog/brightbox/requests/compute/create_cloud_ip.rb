module Fog
  module Compute
    class Brightbox
      class Real
        # Requests a new cloud IP address for the account.
        #
        # @param [Hash] options
        # @option options [String] :reverse_dns Reverse DNS hostname
        # @option options [String] :name Name for Cloud IP
        # @option options [Array] :port_translators Port on which external clients connect and port on which your service is listening.
        #
        # @return [Hash, nil] The JSON response parsed to a Hash or nil if no options passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#cloud_ip_create_cloud_ip
        #
        def create_cloud_ip(options = {})
          request("post", "/1.0/cloud_ips", [201], options)
        end

      end
    end
  end
end
