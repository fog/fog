module Fog
  module Orchestration
    class OpenStack
      class Real
        def list_resources(stack, options={})
          uri = "stacks/#{stack.stack_name}/#{stack.id}/resources"
          request(:method => 'GET', :path => uri, :expects => 200, :query => options)
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
