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

          Excon::Response.new(
            :body   => { 'resources' => resources },
            :status => 200
          )
        end
      end
    end
  end
end
