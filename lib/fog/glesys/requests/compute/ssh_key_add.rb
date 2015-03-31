module Fog
  module Compute
    class Glesys
      class Real
        def ssh_key_add(options)
          request("sshkey/add", options)
        end
      end
    end
  end
end
