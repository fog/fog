module Fog
  module Compute
    class Google
      class Mock
        def delete_url_map(name)
          get_url_map(name)
          url_map = self.data[:url_maps][name]
          url_map["mock-deletionTimestamp"] = Time.now.iso8601
          url_map["status"] = "DONE"
          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global",
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/urlMaps/#{name}",
            "targetId" => self.data[:url_maps][name]["id"],
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
        def delete_url_map(name)
          api_method = @compute.url_maps.delete
          parameters = {
            'project' => @project,
            'urlMap' => name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
