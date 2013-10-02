module Fog
  module Compute
    class Google

      module Shared
        def find_zone(zone_name)
          if zone_name.nil?
            list_zones.body['items'].each do |zone|
              if get_server(server_name, zone['name']).status == 200
                return zone['name']
              end
            end
          else
            if zone_name.is_a? Excon::Response
              return zone_name.body["name"]
            end
          end
          return zone_name
        end
      end

      class Mock
        include Shared

        def delete_server(server_name, zone_name=nil)
          zone_name = find_zone(zone_name)
          get_server(server_name, zone_name)
          server = self.data[:servers][server_name]
          server["status"] = "STOPPED"
          server["mock-deletionTimestamp"] = Time.now.iso8601
          build_response(:body => {
            "kind" => "compute#operation",
            "id" => "10035781241131638365",
            "name" => "operation-1380213292196-4e74bf2fbc3c1-ae707d47",
            "zone" => "https://www.googleapis.com/compute/v1beta15/projects/#{@project}/zones/#{zone_name}",
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/v1beta15/projects/#{@project}/zones/#{zone_name}/instances/#{server_name}",
            "targetId" => "14544909043643897380",
            "status" => "PENDING",
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/v1beta15/projects/#{@project}/zones/#{zone_name}/operations/operation-1380213292196-4e74bf2fbc3c1-ae707d47"
          })
        end

      end

      class Real
        include Shared

        def delete_server(server_name, zone_name=nil)
          zone_name = find_zone(zone_name)
          api_method = @compute.instances.delete
          parameters = {
            'project' => @project,
            'zone' => zone_name,
            'instance' => server_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
