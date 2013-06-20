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

          # We need to get the right owner for an image.
          owners = [ @project, 'google', 'debian-cloud', 'centos-cloud' ]
          @image_url = @api_url + "google/global/images/#{image_name}"
          for owner in owners do
            if !self.get_image(image_name, owner).data['error'].nil?
              p "FOUND!"
              @image_url = @api_url + owner + "/global/images/#{image_name}"
            end
          end

          api_method = @compute.instances.insert
          parameters = {
            'project' => @project,
            'zone' => zone_name,
          }
          body_object = {
            'name' => server_name,
            'image' => @image_url,
            'machineType' => @api_url + @project + "/zones/#{zone_name}/machineTypes/#{machine_name}",
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
