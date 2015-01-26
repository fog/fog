module Fog
  module Compute
    class Google
      class Mock
        def list_machine_types(zone_name)
          get_zone(zone_name)
          machine_types = data[:machine_types][zone_name].values
          build_excon_response({
            "kind" => "compute#machineTypeList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/machineTypes",
            "id" => "projects/high-cistern-340/zones/us-central1-a/machineTypes",
            "items" => machine_types
          })
        end
      end

      class Real
        def list_machine_types(zone_name)
          api_method = @compute.machine_types.list
          parameters = {
            'project' => @project,
            'zone' => zone_name,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
