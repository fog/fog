module Fog
  module Compute
    class Openvz
      class Real
        def exec2_server(id,args)
          vzctl("exec2",{:ctid => id},args)
        end
      end

      class Mock
        def exec2_server(id, args)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
