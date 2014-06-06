module Fog
  module Compute
    class Brightbox
      class Real
        # Create a new application for the user.
        #
        # @param [Hash] options
        # @option options [String] :name
        # @option options [String] :description
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#application_create_application
        #
        def create_application(options)
          wrapped_request("post", "/1.0/applications", [201], options)
        end
      end
    end
  end
end
