module Fog
  module Compute
    class Brightbox
      class Real

        def get_application(identifier)
          return nil if identifier.nil? || identifier == ""
          request("get", "/1.0/applications/#{identifier}", [200])
        end

      end
    end
  end
end