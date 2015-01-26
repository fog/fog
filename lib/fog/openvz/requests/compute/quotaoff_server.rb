module Fog
  module Compute
    class Openvz
      class Real
        def quotaooff_server(id, options = {})
          vzctl("quotaoff",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def quotaooff_server(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
