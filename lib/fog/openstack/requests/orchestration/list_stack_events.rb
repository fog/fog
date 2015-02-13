module Fog
  module Orchestration
    class OpenStack
      class Real
        def list_stack_events(stack, options={})
          uri = "stacks/#{stack.stack_name}/#{stack.id}/events"
          request(:method => 'GET', :path => uri, :expects => 200, :query => options )
        end
      end

      class Mock
        def list_stack_events
          events = self.data[:events].values

          Excon::Response.new(
            :body   => { 'events' => events },
            :status => 200
          )
        end
      end
    end
  end
end
