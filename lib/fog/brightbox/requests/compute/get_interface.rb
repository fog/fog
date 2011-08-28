module Fog
  module Compute
    class Brightbox
      class Real

        def get_interface(identifier)
          return nil if identifier.nil? || identifier == ""
          request("get", "/1.0/interfaces/#{identifier}", [200])
        end

      end
    end
  end
end