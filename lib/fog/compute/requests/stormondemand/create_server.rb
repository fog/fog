module Fog
  module Stormondemand
    class Compute
      class Real

        def create_server(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/storm/server/create",
            :headers  => {"Content-Type" => "application/json"},
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end