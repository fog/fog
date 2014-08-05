module Fog
  module Compute
    class Openvz
      class Real
        def list_servers(options = {})
          vzlist({})
        end
      end

      class Mock
        def list_servers
          self.data[:servers]
        end
      end
    end
  end
end
