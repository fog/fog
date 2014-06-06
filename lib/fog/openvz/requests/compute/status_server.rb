module Fog
  module Compute
    class Openvz
      class Real
        def status_server(id, options = {})
          vzctl("status",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def status_server(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
