module Fog
  module Compute
    class Glesys
      class Real
        def destroy(options)
          if options[:keepip].nil?
            options[:keepip] = 0
          end

          request("/server/destroy", options)
        end
      end
    end
  end
end
