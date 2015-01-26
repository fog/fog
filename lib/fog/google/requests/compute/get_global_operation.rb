module Fog
  module Compute
    class Google
      class Mock
        def get_global_operation(operation)
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
                  "message" => "The resource 'projects/#{project}/global/operations/#{operation}' was not found"
                 }
                ],
                "code" => 404,
                "message" => "The resource 'projects/#{project}/global/operations/#{operation}' was not found"
              }
            }
          end
          build_excon_response(operation)
        end
      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/globalOperations

        def get_global_operation(operation)
          api_method = @compute.global_operations.get
          parameters = {
            'project' => @project,
            'operation' => operation
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
