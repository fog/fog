module Fog
  module Compute
    class Glesys
      class Real
        def start(param)
          request("/server/start", param)
        end
      end
    end
  end
end
