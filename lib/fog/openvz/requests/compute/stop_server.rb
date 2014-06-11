module Fog
  module Compute
    class Openvz
      class Real
        def stop_server(id, options = {})
          vzctl("stop",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def stop_server(id, options = {})
           server = self.data[:servers].find { |s| s['ctid'].to_s == id.to_s }
            unless server.nil?
                 server['status'] = 'stopped'
            end
        end
      end
    end
  end
end
