module Fog
  module Compute
    class Google
      class Mock
        def get_region_view(region_view_name, region)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_region_view(region_view_name, region)
          api_method = @resourceviews.region_views.get
          parameters = {
            'projectName' => @project,
            'resourceViewName' => region_view_name,
            'region' => region
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
