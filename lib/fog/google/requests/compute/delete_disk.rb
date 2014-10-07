module Fog
  module Compute
    class Google
      class Mock
        def delete_disk(disk_name, zone_name)
          get_disk(disk_name, zone_name)

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}",
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/disks/#{disk_name}",
            "targetId" => self.data[:disks][disk_name]["id"],
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/operations/#{operation}"
          }
          self.data[:disks].delete disk_name

          build_excon_response(self.data[:operations][operation])
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

          request(api_method, parameters)
        end
      end
    end
  end
end
