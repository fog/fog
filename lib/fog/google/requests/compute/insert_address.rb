module Fog
  module Compute
    class Google

      class Mock

        def insert_address(address_name, region_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_address(address_name, region_name)
          api_method = @compute.addresses.insert
          parameters = {
            'project' => @project,
            'region' => region_name,
          }
          body_object = { 'name' => address_name }

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
