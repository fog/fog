module Fog
  module Brightbox
    class Compute
      class Real

        def list_cloud_ips(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/1.0/cloud_ips",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end