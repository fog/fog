module Fog
  module Compute
    class Google
      class Mock
        def get_region(identity)
          rname = identity.split('/')[-1]
          region = self.data[:regions][rname] || {
            "error" => {
              "errors" => [
               {
                "domain" => "global",
                "reason" => "notFound",
                "message" => "The resource 'projects/#{project}/regions/#{rname}' was not found"
               }
              ],
              "code" => 404,
              "message" => "The resource 'projects/#{project}/regions/#{rname}' was not found"
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
