module Fog
  module Rackspace
    class Orchestration
      class Real
        def list_resources(stack, options={})
          uri = request_uri("stacks/#{stack.stack_name}/#{stack.id}/resources", options)
          request(:method => 'GET', :path => uri, :expects => 200)
        end
      end

      class Mock
        def list_resources(stack)
          resources = self.data[:resources].values
          response(:body => { 'resources' => resources })
        end
      end
    end
  end
end
