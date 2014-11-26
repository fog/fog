module Fog
  module Compute
    class Google
      class Mock
        def delete_zone_operation(zone, operation)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/zoneOperations

        def delete_zone_operation(zone_name_or_url, operation)
          zone_name = get_zone_name(zone_name_or_url)
          api_method = @compute.zone_operations.delete
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
