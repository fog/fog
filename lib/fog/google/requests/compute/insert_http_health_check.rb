module Fog
  module Compute
    class Google
      class Mock
        def insert_http_health_check(name, options={})
          id = Fog::Mock.random_numbers(19).to_s
          self.data[:http_health_checks][name] = {
            "kind" => "compute#httpHealthCheck",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "name" => name,
            "description" => '',
            "host" => '0.00.0.0',
            "requestPath" => '/',
            "port" => 80,
            "checkIntervalSec" => 5,
            "timeoutSec" => 5,
            "unhealthyThreshold" => 2,
            "healthyThreshold" => 2,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/httpHealthChecks/#{name}"
          }

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global",
            "operationType" => "insert",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/httpHealthChecks/#{name}",
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
        def insert_http_health_check(name, opts={})
          api_method = @compute.http_health_checks.insert
          parameters = {
            'project' => @project
          }

          body_object = { 'name' => name }
          body_object.merge!(opts)

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
