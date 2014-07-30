module Fog
  module Compute
    class Google
      class Mock
        def list_url_maps
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_url_maps
          api_method = @compute.url_maps.list
          parameters = {
            'project' => @project
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
