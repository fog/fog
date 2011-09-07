module Fog
  module Compute
    class Brightbox
      class Real

        def create_api_client(options)
          request("post", "/1.0/api_clients", [201], options)
        end

      end
    end
  end
end