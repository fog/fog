module Fog
  module Compute
    class Google
      class Mock
        def insert_url_map(url_map_name, opts)
          id = Fog::Mock.random_numbers(19).to_s
          self.data[:url_maps][url_map_name] = {
            "kind" => "compute#urlMap",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "name" => url_map_name,
            "description" => '',
            "hostRules" => [],
            "pathMatchers" => [],
            "tests" => [],
            "defaultService" => opts['defaultService'],
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/urlMaps/#{url_map_name}"
          }

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global",
            "operationType" => "insert",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/urlMaps/#{url_map_name}",
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
        def insert_url_map(url_map_name, opts = {})
          api_method = @compute.url_maps.insert
          parameters = {
            'project' => @project,
          }
          body_object = { 'name' => url_map_name }
          body_object.merge!(opts)

          request(api_method, parameters, body_object=body_object)
        end
      end
    end
  end
end
