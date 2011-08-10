module Fog
  module Compute
    class Glesys
      class Real

        def template_list(options = {})
          request("/server/templates", options)
        end
      end

    end
  end
end

