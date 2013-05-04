module Fog
  module Compute
    class Google

      class Mock

        def delete_server(server_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def delete_server(server_name, zone_name=nil)
          if zone_name.nil?
            list_zones.body['items'].each do |zone|
              data = get_server(server_name, zone['name']).body
              if data["error"].nil?
                zone_name = zone['name']
              end
            end
          end

          api_method = @compute.instances.delete
          parameters = {
            'project' => @project,
            'zone' => zone_name,
            'instance' => server_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
