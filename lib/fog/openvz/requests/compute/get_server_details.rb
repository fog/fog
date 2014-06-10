module Fog
  module Compute
    class Openvz
      class Real
        def get_server_details(id)
          vzlist({:ctid => id}).first
        end
      end

      class Mock
        def get_server_details(id)
          return self.data[:servers].find { |s| s['ctid'].to_s == id.to_s }
        end
      end
    end
  end
end
