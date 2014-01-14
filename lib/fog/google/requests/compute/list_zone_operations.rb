module Fog
  module Compute
    class Google

      class Mock

        def list_zone_operations(zone)
          Fog::Mock.not_implemented
        end

      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/zoneOperations

        def list_zone_operations(zone_name_or_url)
          api_method = @compute.zone_operations.list
          parameters = zone_request_parameters(zone_name_or_url)
          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
