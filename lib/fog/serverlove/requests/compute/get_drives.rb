module Fog
  module Compute
    class Serverlove
      class Real

        def get_drives
          request(:method => "get", :path => "/drives/list", :expects => 200)
        end

      end
    end
  end
end