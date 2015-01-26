module Fog
  module Compute
    class Google
      class Mock
        def delete_global_forwarding_rule(name, region_name = 'global')
          get_global_forwarding_rule(name)
          global_forwarding_rule = self.data[:global_forwarding_rules][name]
          global_forwarding_rule["mock-deletionTimestamp"] = Time.now.iso8601
          global_forwarding_rule["status"] = "DONE"
          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global",
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/forwardingRules/#{name}",
            "targetId" => self.data[:global_forwarding_rules][name]["id"],
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
        def delete_global_forwarding_rule(global_forwarding_rule_name, region_name = 'global')
          if region_name.start_with? 'http'
            region_name = region_name.split('/')[-1]
          end

          api_method = @compute.global_forwarding_rules.delete
          parameters = {
            'project' => @project,
            'forwardingRule' => global_forwarding_rule_name,
            'region' => region_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
