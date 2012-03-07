module Fog
  module Compute
    class Joyent
      class Real
        def reboot_machine(id)
          request(
            :method => "POST",
            :query => {"action" => "reboot"},
            :path => "/my/machines/#{id}"
          )
        end
      end
    end
  end
end
