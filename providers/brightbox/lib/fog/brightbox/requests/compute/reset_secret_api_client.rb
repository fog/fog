module Fog
  module Compute
    class Brightbox
      class Real
        # Resets the secret used by the API client to a new generated value.
        #
        # The response is the only time the new secret is available in plaintext.
        #
        # Already authenticated tokens will still continue to be valid until expiry.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#api_client_reset_secret_api_client
        #
        def reset_secret_api_client(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/api_clients/#{identifier}/reset_secret", [200])
        end
      end
    end
  end
end
