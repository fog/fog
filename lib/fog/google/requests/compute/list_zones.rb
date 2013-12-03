module Fog
  module Compute
    class Google

      class Mock

        def list_zones
          zones = self.data[:zones].values
          build_response(:body => {
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

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
