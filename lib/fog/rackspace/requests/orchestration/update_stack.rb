module Fog
  module Rackspace
    class Orchestration
      class Real
        def update_stack(stack, options = {})
          request(
            :body     => Fog::JSON.encode(options),
            :expects  => [202],
            :method   => 'PUT',
            :path     => "stacks/#{stack.stack_name}/#{stack.id}"
          )
        end
      end
    end
  end
end
