module Fog
  module Compute
    class Glesys
      class Real
        def server_details(serverid, options = {})
          request("/server/details", { :serverid => serverid }.merge!(options) )
        end
      end
    end
  end
end
