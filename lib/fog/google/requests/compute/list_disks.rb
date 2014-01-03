module Fog
  module Compute
    class Google

      class Mock

        def list_disks(zone_name)
          disks = self.data[:disks].values.select{|d| d["zone"].split("/")[-1] == zone_name}
          build_response(:body => {
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

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
