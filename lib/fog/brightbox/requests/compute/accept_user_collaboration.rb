module Fog
  module Compute
    class Brightbox
      class Real
        # Accepts the collaboration and gaining permitted access
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#user_collaboration_accept_user_collaboration
        #
        def accept_user_collaboration(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/user/collaborations/#{identifier}/accept", [200])
        end

      end
    end
  end
end
