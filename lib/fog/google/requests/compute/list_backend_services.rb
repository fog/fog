module Fog
  module Compute
    class Google
      class Mock
        def list_backend_services
          backend_services = self.data[:backend_services].values

          build_excon_response({
            "kind" => "compute#backendServiceList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/backendServices",
            "id" => "projects/#{@project}/global/backendServices",
            "items" => backend_services
          })
        end
      end

      class Real
        def list_backend_services
          api_method = @compute.backend_services.list
          parameters = {
            'project' => @project,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
