module Fog
  module Compute
    class Brightbox
      class Real
        # Update some details of the cloud IP address.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :reverse_dns Reverse DNS hostname
        # @option options [String] :name Name for Cloud IP
        # @option options [Array] :port_translators Port on which external clients connect and port on which your service is listening.
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#cloud_ip_update_cloud_ip
        #
        def update_cloud_ip(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          wrapped_request("put", "/1.0/cloud_ips/#{identifier}", [200], options)
        end

      end
    end
  end
end
