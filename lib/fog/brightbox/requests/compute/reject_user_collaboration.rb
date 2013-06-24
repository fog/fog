module Fog
  module Compute
    class Brightbox
      class Real
        # Rejects the collaboration and removes the offer
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#user_collaboration_reject_user_collaboration
        #
        def reject_user_collaboration(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/user/collaborations/#{identifier}/reject", [200])
        end

      end
    end
  end
end
