module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of server types available to the account.
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_type_list_server_types
        #
        def list_server_types
          wrapped_request("get", "/1.0/server_types", [200])
        end
      end
    end
  end
end
