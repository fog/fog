module Fog
  module Compute
    class Google
      class Mock
        def get_url_map(name)
          url_map = self.data[:url_maps][name]
          if url_map.nil?
            return nil
          end
          build_excon_response(url_map)
        end
      end

      class Real
        def get_url_map(name)
          api_method = @compute.url_maps.get
          parameters = {
            'project' => @project,
            'urlMap' => name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
