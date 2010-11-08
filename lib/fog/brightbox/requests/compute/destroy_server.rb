module Fog
  module Brightbox
    class Compute
      class Real

        def destroy_server(identifier, options = {})
          request(
            :expects  => [202],
            :method   => 'DELETE',
            :path     => "/1.0/servers/#{identifier}",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end

      class Mock

        def destroy_server(identifier, options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end