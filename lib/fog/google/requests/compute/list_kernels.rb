module Fog
  module Compute
    class Google

      class Mock

        def list_kernels
          Fog::Mock.not_implemented
        end

      end

      class Real

        def list_kernels
          api_method = @compute.kernels.list
          parameters = {
            'project' => 'google'
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
