module Fog
  module Compute
    class Brightbox
      class Real

        def destroy_server(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/servers/#{identifier}", [202])
        end

      end
    end
  end
end