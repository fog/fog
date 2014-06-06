module Fog
  module Compute
    class Openvz
      class Real
        def quotaon_server(id, options = {})
          vzctl("quotaon",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def quotaon_server(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
