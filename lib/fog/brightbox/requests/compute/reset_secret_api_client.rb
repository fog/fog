module Fog
  module Compute
    class Brightbox
      class Real

        def reset_secret_api_client(identifier)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/api_clients/#{identifier}/reset_secret", [200])
        end

      end
    end
  end
end