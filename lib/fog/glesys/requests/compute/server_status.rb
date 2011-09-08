module Fog
  module Compute
    class Glesys
      class Real

        def server_status(serverid)
          request("/server/status", { :serverid => serverid } )
        end
      end

    end
  end
end

