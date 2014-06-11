module Fog
  module Compute
    class Openvz
      class Real
        def destroy_server(id, options = {})
          vzctl("destroy",{:ctid => id}.merge(options))
        end
      end

      class Mock
        def destroy_server(id , options = {})
          self.data[:servers].reject! { |s| s['ctid'].to_s == id.to_s }
        end
      end
    end
  end
end
