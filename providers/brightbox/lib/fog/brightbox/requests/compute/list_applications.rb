module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of applications available to the user
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#application_list_applications
        #
        def list_applications
          wrapped_request("get", "/1.0/applications", [200])
        end
      end
    end
  end
end
