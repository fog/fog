module Fog
  module Compute
    class Google

      class Mock

        def insert_disk(disk_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_disk(disk_name, disk_size, zone_name=@default_zone)
          api_method = @compute.disks.insert
          parameters = {
            'project' => @project,
            'zone' => zone_name
          }
          body_object = {
            'name' => disk_name,
            'sizeGb' => disk_size,
          }

          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
