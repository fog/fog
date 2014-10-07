module Fog
  module Compute
    class Google
      class Mock
        def list_target_pools(region_name)
          target_pools = self.data[:target_pools].values.select{|d| d["region"].split("/")[-1] == region_name}
          build_excon_response({
            "kind" => "compute#forwardingRuleList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/targetPools",
            "id" => "projects/#{@project}/regions/#{region_name}/regions",
            "items" => target_pools
          })
        end
      end

      class Real
        def list_target_pools(region_name)
          api_method = @compute.target_pools.list
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
