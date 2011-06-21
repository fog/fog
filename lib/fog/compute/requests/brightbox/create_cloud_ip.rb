module Fog
  module Compute
    class Brightbox
      class Real

        def create_cloud_ip(options = {})
          request(
            :expects  => [201],
            :method   => 'POST',
            :path     => "/1.0/cloud_ips",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end