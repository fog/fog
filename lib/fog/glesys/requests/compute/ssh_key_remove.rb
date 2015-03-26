module Fog
  module Compute
    class Glesys
      class Real
        def ssh_key_remove(options)
          request("sshkey/remove", options)
        end
      end
    end
  end
end
