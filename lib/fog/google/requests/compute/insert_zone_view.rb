module Fog
  module Compute
    class Google
      class Mock
        def insert_zone_view(zone_view_name, zone_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_zone_view(zone_view_name, zone_name, opts = {})
          api_method = @resourceviews.zone_views.insert
          parameters = {
            'projectName' => @project,
            'zone' => zone_name
#            'zone' => zone_name
          }
          body_object = { 'name' => zone_view_name }
          body_object.merge!(opts)

          request(api_method, parameters, body_object=body_object)
        end
      end
    end
  end
end

