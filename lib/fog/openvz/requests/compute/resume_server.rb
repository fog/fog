module Fog
  module Compute
    class Openvz
      class Real
        def resume_server(id, options = {})
          vzctl("resume",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def resume_server(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
