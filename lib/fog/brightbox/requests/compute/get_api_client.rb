module Fog
  module Compute
    class Brightbox
      class Real

        def get_api_client(identifier)
          return nil if identifier.nil? || identifier == ""
          request("get", "/1.0/api_clients/#{identifier}", [200])
        end

      end
    end
  end
end