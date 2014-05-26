module Fog
  module Compute
    class Glesys
      class Real
        def ip_remove(params)
          request("/ip/remove", params)
        end
      end
    end
  end
end
