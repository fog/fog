module Fog
  module Compute
    class Brightbox
      class Real

        def list_zones(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/1.0/zones",
            :headers  => {"Content-Type" => "application/json"},
            :body     => MultiJson.encode(options)
          )
        end

      end
    end
  end
end