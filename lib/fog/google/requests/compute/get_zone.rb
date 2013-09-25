module Fog
  module Compute
    class Google

      class Mock

        def get_zone(zone_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def get_zone(zone_name)
          api_method = @compute.zones.get
          parameters = {
            'project' => @project,
            'zone' => zone_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
