module Fog
  module Compute
    class Google

      class Mock

        def get_machine_type(machine_type_name, zone_name = nil)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def get_machine_type(machine_type_name, zone_name = nil)
          zone_name = list_zones.body['items'].first['name'] if zone_name.nil?
          if zone_name.start_with? 'http'
            zone_name = zone_name.split('/')[-1]
          end
          api_method = @compute.machine_types.get
          parameters = {
            'zone' => zone_name,
            'project' => 'google',
            'machineType' => machine_type_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
