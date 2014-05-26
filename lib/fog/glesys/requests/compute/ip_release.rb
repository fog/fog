module Fog
  module Compute
    class Glesys
      class Real
        def ip_release(params)
          request("/ip/release", params)
        end
      end
    end
  end
end
