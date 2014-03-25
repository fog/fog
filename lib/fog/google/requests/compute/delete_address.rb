module Fog
  module Compute
    class Google

      class Mock

        def delete_address(address_name, region_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def delete_address(address_name, region_name)
          api_method = @compute.addresses.delete
          parameters = {
            'project' => @project,
            'address' => address_name,
            'region' => region_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
