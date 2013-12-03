module Fog
  module Compute
    class Brightbox
      class Real
        # Enable console access via VNC to the server for 15 minutes.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_activate_console_server
        #
        def activate_console_server(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/servers/#{identifier}/activate_console", [202])
        end

      end
    end
  end
end
