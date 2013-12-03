module Fog
  module Compute
    class Brightbox
      class Real
        # Destroy the server group if not in use.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_group_delete_server_group
        #
        def delete_server_group(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("delete", "/1.0/server_groups/#{identifier}", [202])
        end

        # Old format of the delete request.
        #
        # @deprecated Use +#delete_server_group+ instead
        #
        def destroy_server_group(identifier)
          delete_server_group(identifier)
        end
      end
    end
  end
end
