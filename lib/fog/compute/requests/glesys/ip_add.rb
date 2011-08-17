module Fog
  module Compute
    class Glesys
      class Real

        def ip_add(params)
          request("/ip/add", params)
        end
      end

    end
  end
end

