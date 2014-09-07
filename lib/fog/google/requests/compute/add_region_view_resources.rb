module Fog
  module Compute
    class Google
      class Mock
        def add_region_view_resources(region_view, resources)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def add_region_view_resources(region_view, resources, region)
          api_method = @resourceviews.region_views.add_resources
          parameters = {
            'projectName' => @project,
            'resourceViewName' => region_view,
            'region' => region
          }
          body = {
            'resources' => resources
          }

          request(api_method, parameters, body_object=body)
        end
      end
    end
  end
end
