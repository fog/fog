module Fog
  module Orchestration
    class OpenStack
      class Real
        def create_stack(options={})
          request(
            :body     => Fog::JSON.encode(options),
            :expects  => [201],
            :method   => 'POST',
            :path     => "stacks"
          )
        end
      end
    end
  end
end
