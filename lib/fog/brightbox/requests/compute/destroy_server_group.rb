module Fog
  module Compute
    class Brightbox
      class Real
        # Destroy the server group if not in use.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_group_destroy_server_group
        #
        def destroy_server_group(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/server_groups/#{identifier}", [202])
        end

      end
    end
  end
end
