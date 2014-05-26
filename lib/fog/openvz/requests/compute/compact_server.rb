module Fog
  module Compute
    class Openvz
      class Real
        def compact_server(id,options = {})
          vzctl("compact",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def compact_server(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
