module Fog
  module Compute
    class Google

      class Mock

        def delete_disk(disk_name, zone_name)
          get_disk(disk_name, zone_name)
          self.data[:disks].delete disk_name

          build_response(:body => {
            "kind" => "compute#operation",
            "id" => "7145812689701515415",
            "name" => "operation-1385125998242-4ebc3c7173e70-11e1ad0b",
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}",
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/disks/#{disk_name}",
            "targetId" => "6817095360746367667",
            "status" => "PENDING",
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/operations/operation-1385125998242-4ebc3c7173e70-11e1ad0b"
          })
        end

      end

      class Real

        def delete_disk(disk_name, zone_name)
          if zone_name.start_with? 'http'
            zone_name = zone_name.split('/')[-1]
          end

          api_method = @compute.disks.delete
          parameters = {
            'project' => @project,
            'disk' => disk_name,
            'zone' => zone_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
