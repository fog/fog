module Fog
  module Compute
    class Google

      class Mock

        def insert_disk(disk_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_disk(disk_name, disk_size, zone_name=@default_zone, image_name=nil)
          api_method = @compute.disks.insert
          parameters = {
            'project' => @project,
            'zone' => zone_name
          }
          if image_name
            # We don't know the owner of the image.
            image = images.create({:name => image_name})
            @image_url = @api_url + image.resource_url
            parameters['sourceImage'] = @image_url
          end
          body_object = {
            'name' => disk_name,
            'sizeGb' => disk_size,
          }

          result = self.build_result(api_method, parameters,
                                     body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
