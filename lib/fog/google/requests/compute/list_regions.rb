module Fog
  module Compute
    class Google

      class Mock

        def list_regions
          regions = self.data[:regions].values
          build_response(:body => {
            "kind" => "compute#regionList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions",
            "id" => "projects/#{@project}/regions",
            "items" => regions
          })
        end

      end

      class Real

        def list_regions
          api_method = @compute.regions.list
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
