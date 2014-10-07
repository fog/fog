module Fog
  module Compute
    class Openvz
      class Real
        def snapshot_server(id,options = {})
          vzctl("snapshot",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def snapshot_server(id,options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
