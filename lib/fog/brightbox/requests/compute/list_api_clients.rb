module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of API clients owned by the account.
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#api_client_list_api_clients
        #
        def list_api_clients
          wrapped_request("get", "/1.0/api_clients", [200])
        end

      end
    end
  end
end
