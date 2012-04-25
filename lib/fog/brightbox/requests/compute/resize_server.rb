module Fog
  module Compute
    class Brightbox
      class Real

        def resize_server(identifier, options = {})
          request(
            :expects  => [202],
            :method   => 'POST',
            :path     => "/1.0/servers/#{identifier}/resize",
            :headers  => {"Content-Type" => "application/json"},
            :body     => Fog::JSON.encode(options)
          )
        end

      end
    end
  end
end