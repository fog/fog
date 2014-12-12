module Fog
  module Rackspace
    class Orchestration
      class Real
        def list_resource_types
          request(
            :method  => 'GET',
            :path    => "resource_types",
            :expects => 200
          )
        end
      end

      class Mock
        def list_resource_types
          resources = self.data[:resource_types].values
          response(:body => { 'resource_types' => resources })
        end
      end
    end
  end
end
