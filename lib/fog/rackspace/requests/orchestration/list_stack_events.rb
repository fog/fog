module Fog
  module Rackspace
    class Orchestration
      class Real
        def list_stack_events(stack, options={})
          uri = request_uri("stacks/#{stack.stack_name}/#{stack.id}/events", options)
          request(:method => 'GET', :path => uri, :expects => 200)
        end
      end

      class Mock
        def list_stack_events
          events = self.data[:events].values
          response(:body => { 'events' => events })
        end
      end
    end
  end
end
