module Fog
  module Compute
    class Brightbox
      class Real
        # Will issue a request to snapshot the Server
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_snapshot_server
        #
        def snapshot_server(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/servers/#{identifier}/snapshot", [202])
        end
      end
    end
  end
end
