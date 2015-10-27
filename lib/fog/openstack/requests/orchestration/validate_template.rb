module Fog
  module Orchestration
    class OpenStack
      class Real
        def validate_template(options = {})
          request(
            :body     => Fog::JSON.encode(options),
            :expects  => [200],
            :method   => 'POST',
            :path     => 'validate'
          )
        end
      end
      class Mock
        def validate_template(options = {})
          Excon::Response.new(
            :body   => { 'description' => "Valid Stack"},
            :status => 200
          )
        end
      end
    end
  end
end
