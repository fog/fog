module Fog
  module Compute
    class Brightbox
      class Real

        def shutdown_server(identifier)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/servers/#{identifier}/shutdown", [202])
        end

      end
    end
  end
end