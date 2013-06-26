module Fog
  module Compute
    class Brightbox
      class Real
        # Ends an existing 'accepted' collaboration
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#user_collaboration_destroy_user_collaboration
        #
        def destroy_user_collaboration(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("delete", "/1.0/user/collaborations/#{identifier}", [200])
        end

      end
    end
  end
end
