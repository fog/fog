module Fog
  module Compute
    class Brightbox
      class Real
        # Lists all collaborations the user is involved with
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#user_collaboration_list_user_collaborations
        #
        def list_user_collaborations
          wrapped_request("get", "/1.0/user/collaborations", [200])
        end
      end
    end
  end
end
