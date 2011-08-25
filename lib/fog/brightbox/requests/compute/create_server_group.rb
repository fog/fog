module Fog
  module Compute
    class Brightbox
      class Real

        def create_server_group(options)
          request("post", "/1.0/server_groups", [202], options)
        end

      end
    end
  end
end