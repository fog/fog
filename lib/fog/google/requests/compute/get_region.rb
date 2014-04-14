module Fog
  module Compute
    class Google

      class Mock
        def get_region(identity)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_region(identity)
          api_method = @compute.regions.get
          parameters = {
            'project' => @project,
            'region' => identity.split('/')[-1],
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end

    end
  end
end
