module Fog
  module Compute
    class Brightbox
      class Real
        # Get full details of the API client.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#api_client_get_api_client
        #
        def get_api_client(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/api_clients/#{identifier}", [200])
        end
      end
    end
  end
end
