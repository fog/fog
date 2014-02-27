module Fog
  module Compute
    class Brightbox
      class Real
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#database_server_get_database_server
        #
        def get_database_server(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/database_servers/#{identifier}", [200])
        end

      end
    end
  end
end
