module Fog
  module Brightbox
    class Compute
      class Real

        def destroy_cloud_ip(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          request(
            :expects  => [200],
            :method   => 'DELETE',
            :path     => "/1.0/cloud_ips/#{identifier}",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end