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

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}",
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/instances/#{server_name}",
            "targetId" => self.data[:servers][server_name]["id"],
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/operations/#{operation}"
          }

          build_excon_response(self.data[:operations][operation])
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

          request(api_method, parameters)
        end
      end
    end
  end
end
