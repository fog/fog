module Fog
  module Brightbox
    class Compute
      class Real

        def create_image(options = {})
          request(
            :expects  => [201],
            :method   => 'POST',
            :path     => "/1.0/images",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end