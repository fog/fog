module Fog
  module Compute
    class Openvz
      class Real
        def convert_server(id,options = {})
          vzctl("convert",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def convert_server(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
