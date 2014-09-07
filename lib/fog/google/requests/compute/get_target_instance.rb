module Fog
  module Compute
    class Google
      class Mock
        def get_target_instance(name, zone_name)
          target_instance = self.data[:target_instances][name]
          if target_instance.nil?
            return nil
          end
          build_excon_response(target_instance)
        end
      end

      class Real
        def get_target_instance(target_instance_name, zone_name)
          if zone_name.start_with? 'http'
            zone_name = zone_name.split('/')[-1]
          end

          api_method = @compute.target_instances.get
          parameters = {
            'project' => @project,
            'targetInstance' => target_instance_name,
            'zone' => zone_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
