module Fog
  module Orchestration
    class OpenStack
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

          Excon::Response.new(
            :body   => { 'resource_types' => resources },
            :status => 200
          )
        end
      end
    end
  end
end
