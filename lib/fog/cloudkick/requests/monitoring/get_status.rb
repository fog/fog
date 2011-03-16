module Fog
  module Cloudkick
    class Monitoring
      class Real

        def get_status(options = {})
          query = queryize(options)
          request(
            :headers  => {'Content-Type' => 'application/json'},
            :expects  => [200],
            :method   => 'GET',
            :path     => "/#{API_VERSION}/status/nodes?#{query}"
          )
        end

      end

      class Mock

        def get_status(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
