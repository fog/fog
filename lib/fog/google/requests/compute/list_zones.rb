module Fog
  module Compute
    class Google
      class Mock
        def list_zones
          zones = self.data[:zones].values
          build_excon_response({
            "kind" => "compute#zoneList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones",
            "id" => "projects/#{@project}/zones",
            "items" => zones
          })
        end
      end

      class Real
        def list_zones
          api_method = @compute.zones.list
          parameters = {
            'project' => @project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
