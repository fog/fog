module Fog
  module Compute
    class Google
      class Mock
        def delete_target_instance(name, zone)
          get_target_instance(name, zone)
          target_instance = self.data[:target_instances][name]
          target_instance["mock-deletionTimestamp"] = Time.now.iso8601
          target_instance["status"] = "DONE"
          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone}",
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone}/targetInstances/#{name}",
            "targetId" => self.data[:target_instances][name]["id"],
            "status" => "DONE",
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone}/operations/#{operation}"
          }
         build_excon_response(self.data[:operations][operation])
        end
      end

      class Real
        def delete_target_instance(target_instance_name, zone_name)
          if zone_name.start_with? 'http'
            zone_name = zone_name.split('/')[-1]
          end

          api_method = @compute.target_instances.delete
          parameters = {
            'project' => @project,
            'targetInstance' => target_instance_name,
            'zone' => zone_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
