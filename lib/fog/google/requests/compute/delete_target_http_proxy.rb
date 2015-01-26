module Fog
  module Compute
    class Google
      class Mock
        def delete_target_http_proxy(name)
          get_target_http_proxy(name)
          target_http_proxy = self.data[:target_http_proxies][name]
          target_http_proxy["mock-deletionTimestamp"] = Time.now.iso8601
          target_http_proxy["status"] = "DONE"
          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global",
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/targetHttpProxies/#{name}",
            "targetId" => self.data[:target_http_proxies][name]["id"],
            "status" => "DONE",
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/operations/#{operation}"
          }
         build_excon_response(self.data[:operations][operation])
        end
      end

      class Real
        def delete_target_http_proxy(name)
          api_method = @compute.target_http_proxies.delete
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
