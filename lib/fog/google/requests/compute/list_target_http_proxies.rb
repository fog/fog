module Fog
  module Compute
    class Google
      class Mock
        def list_target_http_proxies
          proxies = self.data[:target_http_proxies].values

          build_excon_response({
            "kind" => "compute#targetHttpProxyList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/targetHttpProxies",
            "id" => "projects/#{@project}/global/targetHttpProxies",
            "items" => proxies
          })
        end
      end

      class Real
        def list_target_http_proxies
          api_method = @compute.target_http_proxies.list
          parameters = {
            'project' => @project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end

