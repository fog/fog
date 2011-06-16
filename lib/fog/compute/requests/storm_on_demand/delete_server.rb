module Fog
  module Compute
    class StormOnDemand
      class Real

        def delete_server(options = {})
          request(
            :path     => "/storm/server/destroy",
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end