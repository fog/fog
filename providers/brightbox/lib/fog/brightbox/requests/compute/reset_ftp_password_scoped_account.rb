module Fog
  module Compute
    class Brightbox
      class Real
        # Resets the image library ftp password for the scoped account
        #
        # @note The response is the only time the new password is available in plaintext.
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        def reset_ftp_password_scoped_account
          wrapped_request("post", "/1.0/account/reset_ftp_password", [200])
        end
      end
    end
  end
end
