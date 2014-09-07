module Fog
  module Compute
    class Google
      class Mock
        def list_global_forwarding_rules(region_name = 'global')
          global_forwarding_rules = self.data[:global_forwarding_rules].values

          build_excon_response({
            "kind" => "compute#forwardingRuleList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/forwardingRules",
            "id" => "projects/#{@project}/global/forwardingRules",
            "items" => global_forwarding_rules
          })
        end
      end

      class Real
        def list_global_forwarding_rules(region_name = 'global')
          api_method = @compute.global_forwarding_rules.list
          parameters = {
            'project' => @project,
            'region' => region_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
