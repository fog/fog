module Fog
  module Compute
    class Google
      class Mock
        def insert_global_forwarding_rule(name, opts = {})
          id = Fog::Mock.random_numbers(19).to_s
          self.data[:global_forwarding_rules][name] = {
            "kind" => "compute#forwardingRule",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "name" => name,
            "description" => '',
            "region" => 'global',
            "IPAddress" => '',
            "IPProtocol" => '',
            "portRange" => '',
            "target" => opts['target'],
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/forwardingRules/#{name}"
          }

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global",
            "operationType" => "insert",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/forwardingRules/#{name}",
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
        def insert_global_forwarding_rule(global_forwarding_rule_name, opts = {})
          api_method = @compute.global_forwarding_rules.insert
          parameters = {
            'project' => @project,
          }
          body_object = { 'name' => global_forwarding_rule_name, 'region' => 'global' }
          body_object.merge!(opts)

          request(api_method, parameters,body_object=body_object)
        end
      end
    end
  end
end
