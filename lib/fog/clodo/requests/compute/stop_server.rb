module Fog
  module Compute
    class Clodo
      class Real
        def stop_server(id)
          body = {'stop' => {}}
          server_action(id, body)
        end
      end

      class Mock
        def stop_server(id)
          body = {'stop' => {}}
          server_action(id, body)
        end
      end
    end
  end
end
