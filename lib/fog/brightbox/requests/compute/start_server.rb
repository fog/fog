module Fog
  module Compute
    class Brightbox
      class Real

        def start_server(identifier)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/servers/#{identifier}/start", [202])
        end

      end
    end
  end
end