module Fog
  module Compute
    class Google

      class Mock

        def insert_disk(disk_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_disk(disk_name, disk_size, zone_name=@default_zone, image=nil)
          api_method = @compute.disks.insert
          parameters = {
            'project' => @project,
            'zone' => zone_name
          }
          if image
            # We need to check if the image is owned by the user or a global image.
            if get_image(image, @project).data[:status] == 200
              parameters['sourceImage'] = @api_url + @project + "/global/images/#{image}"
            else
              parameters['sourceImage'] = @api_url + "google/global/images/#{image}"
            end
          end
          body_object = {
            'name' => disk_name,
            'sizeGb' => disk_size,
          }

          result = self.build_result(api_method, parameters,
                                     body_object)
          puts result.class
          disk_name = MultiJson.load(result.body)["targetLink"].split('/')[-1]
          return get_disk(disk_name, zone_name)
          #response = self.build_response(result)
          #puts response.inspect
          #response
        end

      end

    end
  end
end
