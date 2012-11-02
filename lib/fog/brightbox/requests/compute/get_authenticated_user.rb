module Fog
  module Compute
    class Brightbox
      class Real
        # Requests details about authenticated user from the API
        #
        # === Returns:
        #
        # <tt>Hash</tt>:: The JSON response parsed to a Hash
        #
        def get_authenticated_user
          request("get", "/1.0/user", [200])
        end

      end
    end
  end
end

