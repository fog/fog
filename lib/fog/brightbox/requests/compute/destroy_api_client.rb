module Fog
  module Compute
    class Brightbox
      class Real

        def destroy_api_client(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/api_clients/#{identifier}", [200])
        end

      end
    end
  end
end