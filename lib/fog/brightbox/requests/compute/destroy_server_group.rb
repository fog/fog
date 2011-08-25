module Fog
  module Compute
    class Brightbox
      class Real

        def destroy_server_group(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/server_groups/#{identifier}", [202])
        end

      end
    end
  end
end