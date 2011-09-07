module Fog
  module Compute
    class Brightbox
      class Real

        def activate_console_server(identifier)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/servers/#{identifier}/activate_console", [202])
        end

      end
    end
  end
end