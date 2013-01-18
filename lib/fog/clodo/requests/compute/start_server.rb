module Fog
  module Compute
    class Clodo
      class Real
        def start_server(id)
          body = {'start' => {}}
          server_action(id, body)
        end
      end

      class Mock
        def start_server(id)
          body = {'start' => {}}
          server_action(id, body)
        end
      end
    end
  end
end
