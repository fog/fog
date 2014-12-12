module Fog
  module Rackspace
    class Orchestration
      class Real
        def show_event_details(stack, resource, event_id)
          request(
            :method  => 'GET',
            :path    => "stacks/#{stack.stack_name}/#{stack.id}/resources/#{resource.resource_name}/events/#{event_id}",
            :expects => 200
          )
        end
      end

      class Mock
        def show_event_details(stack, event)
          events = self.data[:events].values
          response(:body => { 'events' => events })
        end
      end
    end
  end
end
