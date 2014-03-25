module Fog
  module Compute
    class Brightbox
      class Real
        # Lists all the account collaborations
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#collaboration_list_collaborations
        #
        def list_collaborations
          wrapped_request("get", "/1.0/collaborations", [200])
        end

      end
    end
  end
end
