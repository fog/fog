module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of server groups owned by the account.
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_group_list_server_groups
        #
        def list_server_groups
          wrapped_request("get", "/1.0/server_groups", [200])
        end
      end
    end
  end
end
