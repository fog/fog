module Fog
  module Compute
    class Google
      class Mock
        def get_target_http_proxy(name)
          proxy = self.data[:target_http_proxies][name]
          if proxy.nil?
            return nil
          end
          build_excon_response(proxy)
        end
      end

      class Real
        def get_target_http_proxy(name)
          api_method = @compute.target_http_proxies.get
          parameters = {
            'project' => @project,
            'targetHttpProxy' => name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
