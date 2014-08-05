module Fog
  module Compute
    class Openvz
      class Real
        def suspend_server(id, options = {})
          vzctl("suspend",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def suspend_server(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
