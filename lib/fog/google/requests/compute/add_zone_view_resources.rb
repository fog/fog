module Fog
  module Compute
    class Google
      class Mock
        def add_zone_view_resources(zone_view, resources)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def add_zone_view_resources(zone_view, resources, zone)
          api_method = @resourceviews.zone_views.addresources
          parameters = {
            'projectName' => @project,
            'resourceViewName' => zone_view.name,
            'zone' => zone
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
