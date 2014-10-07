module Fog
  module Compute
    class Openvz
      class Real
        def mount_server(id, options = {})
          vzctl("mount",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def mount_server(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
