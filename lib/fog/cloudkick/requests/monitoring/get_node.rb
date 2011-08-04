module Fog
  module Cloudkick
    class Monitoring
      class Real

        def get_node(node_id)
          request(
            :headers  => {'Content-Type' => 'application/json'},
            :expects  => [200],
            :method   => 'GET',
            :path     => "/#{API_VERSION}/node/#{node_id}"
          )
        end

      end

      class Mock

        def get_node(node_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
