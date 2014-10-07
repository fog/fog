module Fog
  module Compute
    class Google
      class Mock
        def delete_zone_view(zone_view)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_zone_view(zone_view, zone)
          api_method = @resourceviews.zone_views.delete
          parameters = {
            'projectName' => @project,
            'resourceViewName' => zone_view,
            'zone' => zone
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
