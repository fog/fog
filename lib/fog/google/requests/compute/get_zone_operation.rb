module Fog
  module Compute
    class Google
      class Mock
        def get_zone_operation(zone_name, operation)
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
                  "message" => "The resource 'projects/#{project}/zones/#{zone_name}/operations/#{operation}' was not found"
                 }
                ],
                "code" => 404,
                "message" => "The resource 'projects/#{project}/zones/#{zone_name}/operations/#{operation}' was not found"
              }
            }
          end
          build_excon_response(operation)
        end
      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/zoneOperations

        def get_zone_operation(zone_name, operation)
          if zone_name.start_with? 'http'
            zone_name = zone_name.split('/')[-1]
          end

          api_method = @compute.zone_operations.get
          parameters = {
            'project' => @project,
            'zone' => zone_name,
            'operation' => operation
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
