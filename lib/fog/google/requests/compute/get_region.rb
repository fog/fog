module Fog
  module Compute
    class Google
      class Mock
        def get_region(identity)
          region_name = identity.split('/')[-1]
          region = self.data[:regions][region_name] || {
            "error" => {
              "errors" => [
               {
                "domain" => "global",
                "reason" => "notFound",
                "message" => "The resource 'projects/#{project}/regions/#{region_name}' was not found"
               }
              ],
              "code" => 404,
              "message" => "The resource 'projects/#{project}/regions/#{region_name}' was not found"
            }
          }
          build_excon_response(region)
        end
      end

      class Real
        def get_region(identity)
          api_method = @compute.regions.get
          parameters = {
            'project' => @project,
            'region' => identity.split('/')[-1],
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
