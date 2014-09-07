module Fog
  module Compute
    class Google
      class Mock
        def list_target_instances(zone_name='us-central1-a')
          zone = self.data[:zones][zone_name]
          target_instances = self.data[:target_instances].values.select{|s| s["zone"] == zone_name}
          build_excon_response({
            "kind" => "compute#targetInstanceList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/targetInstances",
            "id" => "projects/#{@project}/zones/#{zone_name}/targetInstances",
            "items" => target_instances
          })
        end
      end

      class Real
        def list_target_instances(zone_name)
          api_method = @compute.target_instances.list
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
