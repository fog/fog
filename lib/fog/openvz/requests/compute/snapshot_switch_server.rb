module Fog
  module Compute
    class Openvz
      class Real
        def snapshot_switch_server(id,options = {})
          vzctl("snapshot-switch",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def snapshot_switch_server(id,options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
