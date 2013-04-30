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

          # We need to check if the image is owned by the user or a global image.
          if get_image(image_name, @project).data['code'] == 200
            image_url = @api_url + @project + "/global/images/#{image_name}"
          else
            image_url = @api_url + "google/global/images/#{image_name}"
          end

          api_method = @compute.instances.insert
          parameters = {
            'project' => @project,
            'zone' => zone_name,
          }
          body_object = {
            'name' => server_name,
            'image' => image_url,
            'machineType' => @api_url + @project + "/global/machineTypes/#{machine_name}",
            'networkInterfaces' => [{
              'network' => @api_url + @project + "/global/networks/#{network_name}"
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
