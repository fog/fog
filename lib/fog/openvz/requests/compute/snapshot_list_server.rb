module Fog
  module Compute
    class Openvz
      class Real
        def snapshot_list_server(id,options = {})
          vzctl("snapshot-list",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def snapshot_list_server(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
