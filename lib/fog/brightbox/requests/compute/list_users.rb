module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of user.
        #
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#user_list_users
        #
        def list_users
          request("get", "/1.0/users", [200])
        end

      end
    end
  end
end
