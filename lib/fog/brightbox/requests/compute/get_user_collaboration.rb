module Fog
  module Compute
    class Brightbox
      class Real
        # Shows details of one collaboration
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#user_collaboration_get_user_collaboration
        #
        def get_user_collaboration(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/user/collaborations/#{identifier}", [200])
        end

      end
    end
  end
end
