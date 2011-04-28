module Fog
  module Stormondemand
    class Compute
      class Real

        def clone_server(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/storm/server/clone",
            :headers  => {"Content-Type" => "application/json"},
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end