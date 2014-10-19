module Fog
  module Compute
    class Google
      class Mock
        def insert_target_instance(target_instance, zone_name, opts = {})
          id = Fog::Mock.random_numbers(19).to_s
          self.data[:target_instances][target_instance] = {
            "kind" => "compute#targetInstance",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "name" => target_instance,
            "description" => '',
            "natPolicy" => '',
            "zone" => zone_name,
            "instance" => opts['instance'],
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/targetInstances/#{target_instance}"
          }

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}",
            "operationType" => "insert",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/targetInstances/#{target_instance}",
            "targetId" => id,
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
        def insert_target_instance(target_instance_name, zone_name, opts = {})
          api_method = @compute.target_instances.insert
          parameters = {
            'project' => @project,
            'zone' => zone_name,
          }
          body_object = { 'name' => target_pool_name }
          body_object.merge!(opts)

          request(api_method, parameters, body_object=body_object)
        end
      end
    end
  end
end
