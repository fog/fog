module Fog
  module Compute
    class Brightbox
      class Real
        # Will issue a safe shutdown request for the server.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_shutdown_server
        #
        def shutdown_server(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/servers/#{identifier}/shutdown", [202])
        end

      end
    end
  end
end
