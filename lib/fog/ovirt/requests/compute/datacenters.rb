module Fog
  module Compute
    class Ovirt
      class Real

        def datacenters filter={}
          client.datacenters(filter)
        end

      end

      class Mock
        def datacenters filter={}
          [ "Solutions", "Solutions2", "Solutions3" ]
        end
      end
    end
  end
end
