module Fog
  module Compute
    class Google
      class Mock
        def add_url_map_path_matchers(url_map, path_matchers)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def add_url_map_path_matchers(url_map, path_matchers)
          api_method = @compute.url_maps.update
          parameters = {
            'project' => @project,
            'urlMap' => url_map.name
          }
          
          if url_map.pathMatchers then
            url_map.pathMatchers.concat(path_matchers)
          else
            url_map.pathMatchers = path_matchers
          end
        
          request(api_method, parameters, body_object=url_map)
        end
      end
    end
  end
end
