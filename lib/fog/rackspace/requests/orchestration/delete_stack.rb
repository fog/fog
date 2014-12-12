module Fog
  module Rackspace
    class Orchestration
      class Real
        def delete_stack(stack)
          request(
            :expects => [204],
            :method  => 'DELETE',
            :path    => "stacks/#{stack.stack_name}/#{stack.id}"
          )
        end
      end
    end
  end
end
