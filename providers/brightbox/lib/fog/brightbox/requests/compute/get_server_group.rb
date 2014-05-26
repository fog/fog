module Fog
  module Compute
    class Brightbox
      class Real
        # Get details of the server group.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_group_get_server_group
        #
        def get_server_group(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/server_groups/#{identifier}", [200])
        end
      end
    end
  end
end
