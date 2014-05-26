module Fog
  module Compute
    class Glesys
      class Real
        def template_list
          request("/server/templates")
        end
      end
    end
  end
end
