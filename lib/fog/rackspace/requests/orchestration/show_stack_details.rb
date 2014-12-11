module Fog
  module Rackspace
    class Orchestration
      class Real
        def show_stack_details(name, id)
          request(
            :method  => 'GET',
            :path    => "stacks/#{name}/#{id}",
            :expects => 200
          )
        end
      end

      class Mock
        def show_stack_details(name, id)
          stack = self.data[:stack].values
          response(:body => { 'stack' => stack })
        end
      end
    end
  end
end
