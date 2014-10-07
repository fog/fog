module Fog
  module Compute
    class Google
      class Mock
        def get_forwarding_rule(name, region_name)
          forwarding_rule = self.data[:forwarding_rules][name]
          region_name = get_region(region_name).body["name"]
          region = self.data[:regions][region_name]
          if forwarding_rule.nil? or forwarding_rule["region"] != region["selfLink"]
            return build_excon_response({
              "error" => {
                "errors" => [
                 {
                  "domain" => "global",
                  "reason" => "notFound",
                  "message" => "The resource 'projects/#{@project}/regions/#{region_name}/forwarding_rules/#{name}' was not found"
                 }
                ],
                "code" => 404,
                "message" => "The resource 'projects/#{@project}/regions/#{region_name}/forwarding_rules/#{name}' was not found"
              }
            })
          end
          build_excon_response(forwarding_rule)
        end
      end

      class Real
        def get_forwarding_rule(forwarding_rule_name, region_name)
          if region_name.start_with? 'http'
            region_name = region_name.split('/')[-1]
          end

          api_method = @compute.forwarding_rules.get
          parameters = {
            'project' => @project,
            'forwardingRule' => forwarding_rule_name,
            'region' => region_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
