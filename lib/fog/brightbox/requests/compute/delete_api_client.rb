module Fog
  module Compute
    class Brightbox
      class Real
        # Destroy the API client.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#api_client_delete_api_client
        #
        def delete_api_client(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("delete", "/1.0/api_clients/#{identifier}", [200])
        end

        # Old format of the delete request.
        #
        # @deprecated Use +#delete_api_client+ instead
        #
        def destroy_api_client(identifier)
          delete_api_client(identifier)
        end
      end
    end
  end
end
