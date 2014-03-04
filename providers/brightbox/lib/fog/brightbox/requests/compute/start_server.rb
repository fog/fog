module Fog
  module Compute
    class Brightbox
      class Real
        # Will issue a start request for the server to become active.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_start_server
        #
        def start_server(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/servers/#{identifier}/start", [202])
        end

      end
    end
  end
end
