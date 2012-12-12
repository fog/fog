module Fog
  module Compute
    class Brightbox
      class Real
        # Destroy the server and free up the resources.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_destroy_server
        #
        def destroy_server(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/servers/#{identifier}", [202])
        end

      end
    end
  end
end
