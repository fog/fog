module Fog
  module Compute
    class Glesys
      class Real

        def ip_list_free(params)
          request("/ip/listfree", params)
        end
      end

    end
  end
end

