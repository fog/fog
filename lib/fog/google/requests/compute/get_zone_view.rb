module Fog
  module Compute
    class Google
      class Mock
        def get_zone_view(zone_view)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_zone_view(zone_view_name, zone)
          api_method = @resourceviews.zone_views.get
          parameters = {
            'projectName' => @project,
            'resourceViewName' => zone_view_name,
            'zone' => zone
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
