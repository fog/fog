module Fog
  module Compute
    class Google
      class Mock
        def list_disks(zone_name)
          disks = self.data[:disks].values.select{|d| d["zone"].split("/")[-1] == zone_name}
          build_excon_response({
            "kind" => "compute#diskList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/disks",
            "id" => "projects/#{@project}/zones/#{zone_name}/disks",
            "items" => disks
          })
        end
      end

      class Real
        def list_disks(zone_name)
          api_method = @compute.disks.list
          parameters = {
            'project' => @project,
            'zone' => zone_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
