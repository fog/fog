module Fog
  module Compute
    class Google
      class Mock
        def insert_forwarding_rule(name, region_name, opts = {})
          # check that region exists
          get_region(region_name)

          id = Fog::Mock.random_numbers(19).to_s
          self.data[:forwarding_rules][name] = {
            "kind" => "compute#forwardingRule",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "name" => name,
            "description" => '',
            "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}",
            "IPAddress" => '',
            "IPProtocol" => '',
            "portRange" => '',
            "target" => opts['target'],
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/forwardingRules/#{name}"
          }

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}",
            "operationType" => "insert",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/forwardingRules/#{name}",
            "targetId" => id,
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/operations/#{operation}"
          }

          build_excon_response(self.data[:operations][operation])
        end
      end

      class Real
        def insert_forwarding_rule(forwarding_rule_name, region_name, opts = {})
          api_method = @compute.forwarding_rules.insert
          parameters = {
            'project' => @project,
            'region' => region_name
          }
          body_object = { 'name' => forwarding_rule_name }
          body_object.merge!(opts)

          request(api_method, parameters, body_object=body_object)
        end
      end
    end
  end
end
