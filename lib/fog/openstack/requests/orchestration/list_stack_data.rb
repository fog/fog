module Fog
  module Orchestration
    class OpenStack
      class Real
        def list_stack_data(options={})
          request(
            :method  => 'GET',
            :path    => 'stacks',
            :expects => 200,
            :query   => options
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
