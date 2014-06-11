module Fog
  module Compute
    class Openvz
      class Real
        def snapshot_umount_server(id,options = {})
          vzctl("snapshot-umount",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def snapshot_umount_server(id,options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
