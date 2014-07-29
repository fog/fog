module Fog
  module Compute
    class Google
      class Mock
        def validate_url_map(url_map)
          Fog::Mock::not_implemented
        end
      end

      class Real
        def validate_url_map(url_map)
          api_method = @compute.url_maps.validate
          parameters = {
            'project' => @project,
            'urlMap' => url_map.name
          }
          body = { 'resource' => url_map }
          result = self.build_result(api_method, parameters, body_object = body)
          response = self.build_response(result)
        end
      end
    end
  end
end
