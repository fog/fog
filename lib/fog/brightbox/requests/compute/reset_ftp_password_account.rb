module Fog
  module Compute
    class Brightbox
      class Real

        # Reset the image library ftp password for the account.
        #
        # The response is the only time the new password is available in plaintext.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#account_reset_ftp_password_account
        #
        def reset_ftp_password_account
          request("post", "/1.0/account/reset_ftp_password", [200])
        end

      end
    end
  end
end
