module Fog
  module Cloudkick
    class Monitoring
      class Real

        def update_node(node_id, options= {})
          query = options.map {|opt| opt.join("=")}.join("&")
          request(
            :headers  => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :expects  => [200],
            :method   => 'PUT',
            :path     => "/#{API_VERSION}/node/#{node_id}?#{query}",
            :body     => query
          )
        end

      end

      class Mock

        def update_node(node_id, options= {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end



