module Fog
  module Compute
    class Brightbox
      class Real

        def stop_server(identifier)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/servers/#{identifier}/stop", [202])
        end

      end
    end
  end
end