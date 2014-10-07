module Fog
  module Compute
    class Google
      class Mock
        def get_region_operation(region_name, operation)
         operation = self.data[:operations][operation]
          if operation
            case operation["status"]
            when Fog::Compute::Google::Operation::PENDING_STATE
              operation["status"] = Fog::Compute::Google::Operation::RUNNING_STATE
              operation["progress"] = 50
            else
              operation["status"] = Fog::Compute::Google::Operation::DONE_STATE
              operation["progress"] = 100
            end
          else
            operation = {
              "error" => {
                "errors" => [
                 {
                  "domain" => "global",
                  "reason" => "notFound",
                  "message" => "The resource 'projects/#{project}/regions/#{region_name}/operations/#{operation}' was not found"
                 }
                ],
                "code" => 404,
                "message" => "The resource 'projects/#{project}/regions/#{region_name}/operations/#{operation}' was not found"
              }
            }
          end
          build_excon_response(operation)
        end
      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/regionOperations

        def get_region_operation(region_name, operation)
          if region_name.start_with? 'http'
            region_name = region_name.split('/')[-1]
          end

          api_method = @compute.region_operations.get
          parameters = {
            'project' => @project,
            'region' => region_name,
            'operation' => operation
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
