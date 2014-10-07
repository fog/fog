module Fog
  module Compute
    class Google
      class Mock
        def list_zone_views(zone_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_zone_views(zone_name)
          api_method = @resourceviews.zone_views.list
          parameters = {
            'projectName' => @project,
            'zone' => zone_name,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
