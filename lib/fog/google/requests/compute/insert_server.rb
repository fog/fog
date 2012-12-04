module Fog
  module Compute
    class Google

      class Mock

        def insert_server(server_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_server(server_name, image_name,
                          zone_name, machine_name,
                          network_name=@default_network)

          api_method = @compute.instances.insert
          parameters = {
            'project' => @project,
          }
          body_object = {
            'name' => server_name,
            'image' => @api_url + "google/images/#{image_name}",
            'zone' => @api_url + @project + "/zones/#{zone_name}",
            'machineType' => @api_url + @project +
              "/machineTypes/#{machine_name}",
            'networkInterfaces' => [{
              'network' => @api_url + @project + "/networks/#{network_name}"
            }]
          }

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
