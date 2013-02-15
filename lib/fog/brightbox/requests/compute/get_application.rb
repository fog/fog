module Fog
  module Compute
    class Brightbox
      class Real
        # Get full details of the application.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#application_get_application
        #
        def get_application(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/applications/#{identifier}", [200])
        end

      end
    end
  end
end
