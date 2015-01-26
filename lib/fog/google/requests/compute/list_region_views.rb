module Fog
  module Compute
    class Google
      class Mock
        def list_region_views(region_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_region_views(region_name)
          api_method = @resourceviews.region_views.list
          parameters = {
            'projectName' => @project,
            'region' => region_name,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
