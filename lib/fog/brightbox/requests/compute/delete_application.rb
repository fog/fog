module Fog
  module Compute
    class Brightbox
      class Real
        # Destroy the application.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#application_delete_application
        #
        def delete_application(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("delete", "/1.0/applications/#{identifier}", [200])
        end

        # Old format of the delete request.
        #
        # @deprecated Use +#delete_application+ instead
        #
        def destroy_application(identifier)
          delete_application(identifier)
        end
      end
    end
  end
end
