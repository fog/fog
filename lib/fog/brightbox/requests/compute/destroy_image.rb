module Fog
  module Compute
    class Brightbox
      class Real

        def destroy_image(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/images/#{identifier}", [202])
        end

      end
    end
  end
end