module Fog
  module Compute
    class Glesys
      class Real
        def create(options = {})
          request('server/create/',options)
        end
      end
    end
  end
end
