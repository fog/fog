module Fog
  module Compute
    class Google

      class Mock

        def list_forwarding_rules(region_name)
          forwarding_rules = self.data[:forwarding_rules].values.select{|d| d["region"].split("/")[-1] == region_name}
          build_response(:body => {
            "kind" => "compute#forwardingRuleList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/forwardingRules",
            "id" => "projects/#{@project}/regions/#{region_name}/regions",
            "items" => forwarding_rules
          })
        end

      end

      class Real

        def list_forwarding_rules(region_name)
          api_method = @compute.forwarding_rules.list
          parameters = {
            'project' => @project,
            'region' => region_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
