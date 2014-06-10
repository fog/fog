module Fog
  module Compute
    class Openvz
      class Real
        def runscript_server(id,args = [])
          vzctl("runscript",{:ctid => id},args)
        end
      end

      class Mock
        def runscript_server(id,args = [])
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
