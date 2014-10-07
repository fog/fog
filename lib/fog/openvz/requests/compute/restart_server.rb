module Fog
  module Compute
    class Openvz
      class Real
        def restart_server(id, options = {})
          vzctl("restart",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def restart_server(id, options = {})
          server = self.data[:servers].find { |s| s['ctid'] == id.to_s }
          unless server.nil?
            server['status'] = 'running'
          end
        end
      end
    end
  end
end
