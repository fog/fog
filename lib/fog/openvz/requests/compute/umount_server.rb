module Fog
  module Compute
    class Openvz
      class Real
        def umount_server(id, options = {})
          vzctl("umount",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def umount_server(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
