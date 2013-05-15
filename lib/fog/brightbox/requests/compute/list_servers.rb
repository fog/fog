module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of servers owned by the account.
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_list_servers
        #
        def list_servers
          wrapped_request("get", "/1.0/servers", [200])
        end

      end
    end
  end
end
