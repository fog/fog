module Fog
  module Compute
    class Glesys
      class Real

        def stop(param)
          request("/server/stop", param)
        end
      end

    end
  end
end

