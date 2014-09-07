module Fog
  module Compute
    class Google
      class Mock
        def list_region_view_resources(region_view)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_region_view_resources(region_view)
          api_method = @resourceviews.region_views.list_resources
          parameters = {
            'projectName' => @project,
            'region' => region_view.region,
            'resourceViewName' => region_view.name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end

