module Fog
  module Compute
    class Brightbox
      class Real
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#database_server_list_database_servers
        #
        def list_database_servers
          wrapped_request("get", "/1.0/database_servers", [200])
        end
      end
    end
  end
end
