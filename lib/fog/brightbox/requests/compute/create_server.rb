module Fog
  module Compute
    class Brightbox
      class Real

        def create_server(options)
          request("post", "/1.0/servers", [202], options)
        end

      end
    end
  end
end