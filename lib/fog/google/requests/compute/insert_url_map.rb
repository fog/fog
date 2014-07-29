module Fog
  module Compute
    class Google
      class Mock
        def insert_url_map(url_map_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_url_map(url_map_name, opts = {})
          api_method = @compute.url_maps.insert
          parameters = {
            'project' => @project,
          }
          body_object = { 'name' => url_map_name }
          body_object.merge!(opts)

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
