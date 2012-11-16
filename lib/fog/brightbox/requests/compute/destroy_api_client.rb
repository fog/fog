module Fog
  module Compute
    class Brightbox
      class Real
        # Destroy the API client.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#api_client_destroy_api_client
        #
        def destroy_api_client(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/api_clients/#{identifier}", [200])
        end

      end
    end
  end
end
