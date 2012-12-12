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
        # @return [Hash, nil] The JSON response parsed to a Hash or nil if no options passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#api_client_create_api_client
        #
        def create_api_client(options)
          request("post", "/1.0/api_clients", [201], options)
        end

      end
    end
  end
end
