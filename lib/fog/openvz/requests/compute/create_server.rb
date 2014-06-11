module Fog
  module Compute
    class Openvz
      class Real
        def create_server(options = {})
          vzctl("create",options)
        end
      end

      class Mock
        def create_server(options = {})
          # When a new fake server is created we set the status to stopped
          options['status'] = 'stopped'
          self.data[:servers] << options
        end
      end
    end
  end
end
