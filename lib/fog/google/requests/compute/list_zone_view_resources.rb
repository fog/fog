module Fog
  module Compute
    class Google
      class Mock
        def list_zone_view_resources(zone_view)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_zone_view_resources(zone_view)
          api_method = @resourceviews.zone_views.list_resources
          parameters = {
            'projectName' => @project,
            'zone' => zone_view.zone,
            'resourceViewName' => zone_view.name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end

