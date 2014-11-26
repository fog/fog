module Fog
  module Compute
    class Google
      module Shared
        def find_zone(server_name)
          list_zones.body['items'].each do |zone|
            if get_server(server_name, zone['name']).status == 200
              return zone['name']
            end
          end
          return nil
        end
      end

      class Mock
        include Shared

        def delete_server(server_name, zone_name_or_url = nil)
          zone_name = zone_name_or_url.nil? ? find_zone(server_name) : get_zone_name(zone_name_or_url)
          
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

        def delete_server(instance_name, zone_name_or_url = nil)
          zone_name = zone_name_or_url.nil? ? find_zone(server_name) : get_zone_name(zone_name_or_url)

          api_method = @compute.instances.delete
          parameters = instance_request_parameters(instance_name, zone_name_or_url)

          request(api_method, parameters)
        end
      end
    end
  end
end
