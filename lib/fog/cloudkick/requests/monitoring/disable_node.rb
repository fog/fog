module Fog
  module Cloudkick
    class Monitoring
      class Real

        def disable_node(node_id)
          request(
            :headers  => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :expects  => [204],
            :method   => 'POST',
            :path     => "/#{API_VERSION}/node/#{node_id}/disable"
          )
        end

      end

      class Mock

        def disable_node(node_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end

