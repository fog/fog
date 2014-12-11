module Fog
  module Rackspace
    class Orchestration
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
    end
  end
end
