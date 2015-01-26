module Fog
  module Compute
    class Google
      class Mock
        def insert_region_view(region_view_name, region_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_region_view(region_view_name, region_name, opts = {})
          api_method = @resourceviews.region_views.insert
          parameters = {
            'projectName' => @project,
            'region' => region_name
          }
          body_object = { 'name' => region_view_name }
          body_object.merge!(opts)

          request(api_method, parameters, body_object=body_object)
        end
      end
    end
  end
end
