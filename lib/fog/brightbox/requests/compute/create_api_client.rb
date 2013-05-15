module Fog
  module Compute
    class Brightbox
      class Real
        # Create a new API client for the account.
        #
        # @param [Hash] options
        # @option options [String] :name
        # @option options [String] :description
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#api_client_create_api_client
        #
        def create_api_client(options)
          wrapped_request("post", "/1.0/api_clients", [201], options)
        end

      end
    end
  end
end
