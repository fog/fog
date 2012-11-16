module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of applications available to the user
        #
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#application_list_applications
        #
        def list_applications
          request("get", "/1.0/applications", [200])
        end

      end
    end
  end
end
