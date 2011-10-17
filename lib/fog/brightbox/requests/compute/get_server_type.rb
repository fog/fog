module Fog
  module Compute
    class Brightbox
      class Real

        def get_server_type(identifier)
          return nil if identifier.nil? || identifier == ""
          request("get", "/1.0/server_types/#{identifier}", [200])
        end

      end
    end
  end
end