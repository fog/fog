module Fog
  module Compute
    class Google
      class Mock
        def get_target_pool(name, region_name)
          region = get_region(region_name)
          target_pool = self.data[:target_pools][name] || {
            "error" => {
              "errors" => [{
                "domain" => "global",
                "reason" => "notFound",
                "message" => "The resource 'projects/#{project}/regions/#{region_name}/targetPools/#{name}' was not found"
              }],
              "code" => 404,
              "message" => "The resource 'projects/#{project}/regions/#{region_name}/targetPools/#{name}' was not found"
            }
          }
          build_excon_response(target_pool)
        end
      end

      class Real
        def get_target_pool(target_pool_name, region_name)
          if region_name.start_with? 'http'
            region_name = region_name.split('/')[-1]
          end

          api_method = @compute.target_pools.get
          parameters = {
            'project' => @project,
            'targetPool' => target_pool_name,
            'region' => region_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
