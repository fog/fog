module Fog
  module Compute
    class Google

      class Mock

        def insert_address(address_name, region_name, options = {})
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_address(address_name, region_name, options = {})
          api_method = @compute.addresses.insert
          parameters = {
            'project' => @project,
            'region' => region_name,
          }
          body_object = { 'name' => address_name }
          body_object['description'] = options[:description] if options[:description]

          result = self.build_result(api_method, parameters, body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
