module Fog
  module Compute
    class Glesys
      class Real

        def server_details(serverid)
          request("/server/details", { :serverid => serverid })
        end
      end

    end
  end
end

