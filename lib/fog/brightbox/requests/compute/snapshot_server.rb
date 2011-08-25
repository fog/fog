module Fog
  module Compute
    class Brightbox
      class Real

        def snapshot_server(identifier)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/servers/#{identifier}/snapshot", [202])
        end

      end
    end
  end
end