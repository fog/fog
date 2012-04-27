module Fog
  module Compute
    class Serverlove
      class Real

        def get_drives
          request(:method => "get", :path => "/drives/info", :expects => 200)
        end

      end
    end
  end
end