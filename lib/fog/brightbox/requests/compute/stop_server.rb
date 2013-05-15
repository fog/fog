module Fog
  module Compute
    class Brightbox
      class Real
        # Will issue a stop request for the server to become inactive.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_stop_server
        #
        def stop_server(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/servers/#{identifier}/stop", [202])
        end

      end
    end
  end
end
