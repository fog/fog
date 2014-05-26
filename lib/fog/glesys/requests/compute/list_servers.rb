module Fog
  module Compute
    class Glesys
      class Real
        def list_servers(serverid = nil, options = {})
          unless serverid.nil?
            options[:serverid] = serverid
          end

          request("/server/list", options)
        end
      end
    end
  end
end
