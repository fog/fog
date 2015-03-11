module Fog
  module Compute
    class Glesys
      class Real
        def edit(options = {})
          request('server/edit/',options)
        end
      end
    end
  end
end
