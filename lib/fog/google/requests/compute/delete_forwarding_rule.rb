module Fog
  module Compute
    class Google
      class Mock
        def delete_forwarding_rule(forwarding_rule_name, region_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/regionOperations

        def delete_forwarding_rule(forwarding_rule_name, region_name)
          if region_name.start_with? 'http'
            region_name = region_name.split('/')[-1]
          end

          api_method = @compute.forwarding_rules.delete
          parameters = {
            'project' => @project,
            'forwardingRule' => forwarding_rule_name,
            'region' => region_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
