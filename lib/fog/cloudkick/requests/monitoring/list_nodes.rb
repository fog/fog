module Fog
  module Cloudkick
    class Monitoring
      class Real

        def list_nodes(options = {})
          query = options.map {|opt| opt.join("=")}.join("&")
          request(
            :headers  => {'Content-Type' => 'application/json'},
            :expects  => [200],
            :method   => 'GET',
            :path     => "/#{API_VERSION}/nodes?#{query}"
          )
        end

      end

      class Mock

        def list_nodes(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end

