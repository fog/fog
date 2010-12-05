module Fog
  module Cloudkick
    class Monitoring
      class Real

        def create_monitor(options= {})
          query = options.map {|opt| opt.join("=")}.join("&")
          request(
            :headers  => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :expects  => [201],
            :method   => 'POST',
            :path     => "/#{API_VERSION}/monitors?#{query}",
            :body     => query
          )
        end

      end

      class Mock

        def create_monitor(options= {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
