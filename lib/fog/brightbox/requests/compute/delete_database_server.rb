module Fog
  module Compute
    class Brightbox
      class Real
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#database_server_delete_database_server
        #
        def delete_database_server(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("delete", "/1.0/database_servers/#{identifier}", [202])
        end

        # Old format of the delete request.
        #
        # @deprecated Use +#delete_database_server+ instead
        #
        def destroy_database_server(identifier)
          delete_database_server(identifier)
        end
      end
    end
  end
end
