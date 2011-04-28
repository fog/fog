module Fog
  module Stormondemand
    class Compute
      class Real

        def list_templates(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/server/template/list",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end