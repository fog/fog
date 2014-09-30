module Fog
  module Compute
    class Google
      class Mock
        def insert_target_http_proxy(name, options={})
          id = Fog::Mock.random_numbers(19).to_s
          self.data[:target_http_proxies][name] = {
            "kind" => "compute#targetHttpProxy",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "name" => name,
            "description" => '',
            "urlMap" => options["urlMap"],
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/targetHttpProxies/#{name}"
          }

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global",
            "operationType" => "insert",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/targetHttpProxies/#{name}",
            "targetId" => id,
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
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
        def insert_target_http_proxy(name, opts={})
          api_method = @compute.target_http_proxies.insert
          parameters = {
            'project' => @project
          }
          body_object = { 'name' => name }
          body_object.merge!(opts)

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
