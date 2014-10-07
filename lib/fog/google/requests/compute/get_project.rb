module Fog
  module Compute
    class Google
      class Mock
        def get_project(identity)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_project(identity)
          api_method = @compute.projects.get
          parameters = {
            :project => identity,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
