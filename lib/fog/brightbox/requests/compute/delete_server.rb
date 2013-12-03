module Fog
  module Compute
    class Brightbox
      class Real
        # Destroy the server and free up the resources.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_delete_server
        #
        def delete_server(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("delete", "/1.0/servers/#{identifier}", [202])
        end

        # Old format of the delete request.
        #
        # @deprecated Use +#delete_server+ instead
        #
        def destroy_server(identifier)
          delete_server(identifier)
        end
      end
    end
  end
end
