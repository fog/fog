module Fog
  module Compute
    class Brightbox
      class Real

        def list_applications
          request("get", "/1.0/applications", [200])
        end

      end
    end
  end
end