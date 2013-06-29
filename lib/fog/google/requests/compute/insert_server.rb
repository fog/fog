module Fog
  module Compute
    class Google

      class Mock

        def insert_server(server_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def format_metadata(metadata)
          { "items" => metadata.map {|k,v| {"key" => k, "value" => v}} }
        end

        def insert_server(server_name, image_name,
                          zone_name, machine_name, metadata,
                          network_name=@default_network)

          # We don't know the owner of the image.
          image = images.create({:name => image_name})
          @image_url = @api_url + image.resource_url

          api_method = @compute.instances.insert
          parameters = {
            'project' => @project,
            'zone' => zone_name,
          }
          body_object = {
            'name' => server_name,
            'image' => @image_url,
            'machineType' => @api_url + @project + "/zones/#{zone_name}/machineTypes/#{machine_name}",
            'metadata' => format_metadata(metadata),
            'networkInterfaces' => [{
              'network' => @api_url + @project + "/global/networks/#{network_name}",
              'accessConfigs' => [{
                'type' => 'ONE_TO_ONE_NAT',
                'name' => 'External NAT',
              }]
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
