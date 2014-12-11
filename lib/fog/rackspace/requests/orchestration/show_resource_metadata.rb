module Fog
  module Rackspace
    class Orchestration
      class Real
        def show_resource_metadata(stack, resource_name)
          request(
            :method  => 'GET',
            :path    => "stacks/#{stack.stack_name}/#{stack.id}/resources/#{resource_name}/metadata",
            :expects => 200
          )
        end
      end

      class Mock
        def show_resource_metadata(stack, resource_name)
          resources = self.data[:resources].values
          response(:body => { 'resources' => resources })
        end
      end
    end
  end
end
