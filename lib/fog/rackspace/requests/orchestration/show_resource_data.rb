module Fog
  module Rackspace
    class Orchestration
      class Real
        def show_resource_data(stack_name, stack_id, resource_name)
          request(
            :method  => 'GET',
            :path    => "stacks/#{stack_name}/#{stack_id}/resources/#{resource_name}",
            :expects => 200
          )
        end
      end

      class Mock
        def show_resource_data(stack_name, stack_id, resource_name)
          resources = self.data[:resources].values
          response(:body => { 'resources' => resources })
        end
      end
    end
  end
end
