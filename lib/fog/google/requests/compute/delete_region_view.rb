module Fog
  module Compute
    class Google
      class Mock
        def delete_region_view(region_view)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_region_view(region_view, region)
          api_method = @resourceviews.region_views.delete
          parameters = {
            'projectName' => @project,
            'resourceViewName' => region_view,
            'region' => region
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
