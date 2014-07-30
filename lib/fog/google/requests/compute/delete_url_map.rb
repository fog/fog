module Fog
  module Compute
    class Google
      class Mock
        def delete_url_map(name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_url_map(name)
          api_method = @compute.url_maps.delete
          parameters = {
            'project' => @project,
            'urlMap' => name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
