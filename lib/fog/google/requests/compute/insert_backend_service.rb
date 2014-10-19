module Fog
  module Compute
    class Google
      class Mock
        def insert_backend_service(backend_service_name, opts ={})
          id = Fog::Mock.random_numbers(19).to_s
          self.data[:backend_services][backend_service_name] = {
            "kind" => "compute#backendService",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "name" => backend_service_name,
            "description" => '',
            "backends" => [
            {
              "description" => '',
              "group" => 'https://www.googleapis.com/resourceviews/v1beta1/projects#{@project}/zones/us-central1-a/zoneViews/name',
              "balancingMode" => "RATE",
              "capacityScaler" => 1.1,
              "maxRate" => 0.5,
            }],
            "healthChecks" => [ opts["health_check"] ],
            "timeoutSec" => 30,
            "port" => 80,
            "protocol" => "TCP",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/backendServices/#{backend_service_name}"
          }

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global",
            "operationType" => "insert",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/backendServces/#{backend_service_name}",
            "targetId" => id,
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/operations/#{operation}"
          }

          build_excon_response(self.data[:operations][operation])
         end
      end

      class Real
        def insert_backend_service(backend_service_name, opts = {})
          api_method = @compute.backend_services.insert
          parameters = {
            'project' => @project
          }
          body_object = { 'name' => backend_service_name }
          body_object.merge!(opts)

          request(api_method, parameters, body_object=body_object)
        end
      end
    end
  end
end
