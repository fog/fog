module Fog
  module Compute
    class Google
      class Mock
        def list_url_maps
          url_maps = self.data[:url_maps].values

          build_excon_response({
            "kind" => "compute#urlMapList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/urlMaps",
            "id" => "projects/#{@project}/global/urlMaps",
            "items" => url_maps
          })
        end
      end

      class Real
        def list_url_maps
          api_method = @compute.url_maps.list
          parameters = {
            'project' => @project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
