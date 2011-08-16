module Fog
  module Compute
    class Brightbox
      class Real

        def get_server(identifier)
          return nil if identifier.nil? || identifier == ""
          request("get", "/1.0/servers/#{identifier}", [200])
        end

      end
    end
  end
end