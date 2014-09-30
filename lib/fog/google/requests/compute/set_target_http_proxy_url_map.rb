module Fog
  module Compute
    class Google
      class Mock
        def set_target_http_proxy_url_map(target_http_proxy, url_map)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_target_http_proxy_url_map(target_http_proxy, url_map)
          api_method = @compute.target_http_proxies.set_url_map
          parameters = {
            'project' => @project,
            'targetHttpProxy' => target_http_proxy.name,
          }
          url_map = url_map.self_link unless url_map.class == String
          body = {
            'urlMap' => url_map
          }

          request(api_method, parameters, body_object=body)
        end
      end
    end
  end
end
