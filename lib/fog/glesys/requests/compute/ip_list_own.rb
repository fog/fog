module Fog
  module Compute
    class Glesys
      class Real

        def ip_list_own(options = {})
          request("/ip/listown", options)
        end
      end

    end
  end
end

