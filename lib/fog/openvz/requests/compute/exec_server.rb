module Fog
  module Compute
    class Openvz
      class Real
        def exec_server(id,args = [])
          vzctl("exec",{:ctid => id},args)
        end
      end

      class Mock
        def exec_server(id, args = [])
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
