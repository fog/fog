module Fog
  module Cloudkick
    class Monitoring
      class Real

        def list_nodes(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/2.0/nodes"
            #:body     => options.to_json
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

