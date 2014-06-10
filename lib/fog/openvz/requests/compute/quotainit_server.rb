module Fog
  module Compute
    class Openvz
      class Real
        def quotainit_server(id, options = {})
          vzctl("quotainit",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def quotainit_server(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
