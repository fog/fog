module Fog
  module Compute
    class Openvz
      class Real
        def set_server(id,options = {})
          vzctl("set",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def set_server(id, options = {})
          server = self.data[:servers].find { |s| s['ctid'].to_s == id.to_s }
          unless server.nil?
            options.each do |k,v|
              server[k] = v
            end
          end
        end
      end
    end
  end
end
