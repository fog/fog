module Fog
  module Compute
    class Google
      class Mock
        def update_url_map(url_map, host_rules)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def update_url_map(url_map, host_rules, path_matchers = nil)
          api_method = @compute.url_maps.update
          parameters = {
            'project' => @project,
            'urlMap' => url_map.name
          }
          
          # add new properties to the url_map resource
          if  url_map.hostRules then
            url_map.hostRules.concat(host_rules)
          else
            url_map.hostRules = host_rules
          end

          # a path matcher can only be created with a host rule that uses it
          if path_matchers then
            if url_map.pathMatchers then
              url_map.pathMatchers.concat(path_matchers)
            else
              url_map.pathMatchers = path_matchers
            end
          end

          request(api_method, parameters, body_object=url_map)
        end
      end
    end
  end
end
