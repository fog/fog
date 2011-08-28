module Fog
  module Compute
    class Brightbox
      class Real

        def get_image(identifier)
          return nil if identifier.nil? || identifier == ""
          request("get", "/1.0/images/#{identifier}", [200])
        end

      end
    end
  end
end