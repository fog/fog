module Fog
  module Rackspace
    class Orchestration
      class Real
        def list_stack_data(options={})
          request(
            :method  => 'GET',
            :path    => request_uri("stacks", options),
            :expects => 200
          )
        end
      end

      class Mock
        def list_stack_data
          stacks = self.data[:stacks].values
          response(:body => { 'stacks' => stacks })
        end
      end
    end
  end
end
