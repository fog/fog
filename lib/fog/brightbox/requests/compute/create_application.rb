module Fog
  module Compute
    class Brightbox
      class Real

        def create_application(options)
          request("post", "/1.0/applications", [201], options)
        end

      end
    end
  end
end