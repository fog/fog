module Fog
  module Compute
    class Google

      class Mock

        def list_regions
          Fog::Mock.not_implemented
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
