module Fog
  module Cloudkick
    class Monitoring
      class Real

        def remove_tag_from_node(node_id, options= {})
          query = options.map {|opt| opt.join("=")}.join("&")
          request(
            :headers  => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :expects  => [204],
            :method   => 'POST',
            :path     => "/#{API_VERSION}/node/#{node_id}/remove_tag?#{query}",
            :body     => query
          )
        end

      end

      class Mock

        def remove_tag_from_node(node_id, options= {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
