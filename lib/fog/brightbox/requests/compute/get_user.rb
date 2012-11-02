module Fog
  module Compute
    class Brightbox
      class Real
        # Requests details about a user from the API
        #
        # === Parameters:
        #
        # <tt>identifier <String></tt>:: The identifier to request (Default is +nil+)
        #
        # === Returns:
        #
        # <tt>Hash</tt>:: The JSON response parsed to a Hash
        #
        # === Notes:
        #
        # This also supports a deprecated form where if an identifier is not
        # passed then the requesting user is returned instead. This should not
        # be used in new code. Use #get_authenticated_user instead.
        #
        # === Reference:
        #
        # https://api.gb1.brightbox.com/1.0/#user_get_user
        #
        def get_user(identifier = nil)
          if identifier.nil? || identifier == ""
            Fog::Logger.deprecation("get_user() without a parameter is deprecated, use get_authenticated_user instead [light_black](#{caller.first})[/]")
            get_authenticated_user
          else
            request("get", "/1.0/users/#{identifier}", [200])
          end
        end

      end
    end
  end
end
