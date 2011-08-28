module Fog
  module Compute
    class Brightbox
      class Real

        def reset_ftp_password_account
          request("post", "/1.0/account/reset_ftp_password", [200])
        end

      end
    end
  end
end