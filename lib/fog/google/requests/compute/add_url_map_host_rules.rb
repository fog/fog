module Fog
  module Compute
    class Google
      class Mock
        def add_url_map_host_rules(url_map, host_rules)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def add_url_map_host_rules(url_map, host_rules)
          api_method = @compute.url_maps.update
          parameters = {
            'project' => @project,
            'urlMap' => url_map.name
          }
          if  url_map.hostRules then  url_map.hostRules.concat( host_rules) else  url_map.hostRules = host_rules end
          body = url_map
        
          request(api_method, parameters, body_object=body)
        end
      end
    end
  end
end
