module Fog
  module Compute
    class Clodo
      class Real
        def reboot_server(id, type)
          body = {'reboot' => {}}
          server_action(id, body)
        end
      end

      class Mock
        def reboot_server(id, type)
          body = {'reboot' => {}}
          server_action(id, body)
        end
      end
    end
  end
end
