module Fog
  module Compute
    class Glesys
      class Real

        def ip_list_free(options = {})
          request("/ip/listfree", options)
        end
      end

    end
  end
end

