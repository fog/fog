module Fog
  module Compute
    class Glesys
      class Real
        def reboot(param)
          request("/server/reboot", param)
        end
      end
    end
  end
end
