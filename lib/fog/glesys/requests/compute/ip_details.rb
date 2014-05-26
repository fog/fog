module Fog
  module Compute
    class Glesys
      class Real
        def ip_details(params)
          request("/ip/details", params)
        end
      end
    end
  end
end
