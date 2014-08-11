module Fog
  module Compute
    class Google
      class Mock
        def get_disk(disk_name, zone_name)
          disk = self.data[:disks][disk_name]
          if zone_name.start_with? 'http'
            zone_name = zone_name.split('/')[-1]
          end
          get_zone(zone_name)
          zone = self.data[:zones][zone_name]
          if disk.nil? or disk["zone"] != zone["selfLink"]
            return build_excon_response({
              "error" => {
                "errors" => [
                 {
                  "domain" => "global",
                  "reason" => "notFound",
                  "message" => "The resource 'projects/#{@project}/zones/#{zone_name}/disks/#{disk_name}' was not found"
                 }
                ],
                "code" => 404,
                "message" => "The resource 'projects/#{@project}/zones/#{zone_name}/disks/#{disk_name}' was not found"
              }
            })
          end

          # TODO transition the disk through the states

          build_excon_response(disk)
        end
      end

      class Real
        def get_disk(disk_name, zone_name)
          if zone_name.start_with? 'http'
            zone_name = zone_name.split('/')[-1]
          end

          api_method = @compute.disks.get
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
