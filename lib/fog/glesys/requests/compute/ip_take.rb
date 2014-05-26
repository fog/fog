module Fog
  module Compute
    class Glesys
      class Real
        def ip_take(params)
          request("/ip/take", params)
        end
      end
    end
  end
end
