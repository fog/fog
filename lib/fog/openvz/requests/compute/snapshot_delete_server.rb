module Fog
  module Compute
    class Openvz
      class Real
        def snapshot_delete_server(id,options = {})
          vzctl("snapshot-delete",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def snapshot_delete_server(id,options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
