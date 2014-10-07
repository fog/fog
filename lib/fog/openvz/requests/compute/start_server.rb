module Fog
  module Compute
    class Openvz
      class Real
        def start_server(id,options={})
          vzctl("start",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def start_server(id,options={})
          server = self.data[:servers].find { |s| s['ctid'].to_s == id.to_s }
          unless server.nil?
            server['status'] = 'running'
          end
        end
      end
    end
  end
end
