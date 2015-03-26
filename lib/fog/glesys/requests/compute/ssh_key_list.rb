module Fog
  module Compute
    class Glesys
      class Real
        def ssh_key_list(options = {})
          request("sshkey/list", options)
        end
      end
    end
  end
end
