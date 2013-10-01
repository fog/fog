module Fog
  module Compute
    class Google

      class Mock

        def get_zone(zone_name)
          zone = self.data[:zones][zone_name] || {
            "error" => {
              "errors" => [
               {
                "domain" => "global",
                "reason" => "notFound",
                "message" => "The resource 'projects/#{project}/zones/#{zone_name}' was not found"
               }
              ],
              "code" => 404,
              "message" => "The resource 'projects/#{project}/zones/#{zone_name}' was not found"
            }
          }
          build_response(:body => zone)
        end

      end

      class Real

        def get_zone(zone_name)
          api_method = @compute.zones.get
          parameters = {
            'project' => @project,
            'zone' => zone_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
