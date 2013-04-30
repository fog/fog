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
            service.list_zones.body['items'].each do |zone|
              service.get_server(identity, zone['name']).body
              zone_name = zone['name']
              break if data["code"] == 200
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
