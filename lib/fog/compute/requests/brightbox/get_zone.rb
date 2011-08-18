module Fog
  module Compute
    class Brightbox
      class Real

        def get_zone(identifier)
          return nil if identifier.nil? || identifier == ""
          request("get", "/1.0/zones/#{identifier}", [200])
        end

      end
    end
  end
end