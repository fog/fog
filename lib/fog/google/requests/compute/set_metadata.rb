module Fog
  module Compute
    class Google

      class Mock

        def set_metadata(instance, zone_name_or_url, metadata={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        def set_metadata(instance, zone_name_or_url = nil, metadata={})
          api_method = @compute.instances.set_metadata

          zone_name = get_zone_name(zone_name_or_url) || instance_zone_name(instance)

          parameters = {
            'project' => @project,
            'instance' => instance,
            'zone' => zone_name
          }

          body_object = {
            'items' => metadata.to_a.map { |pair| { :key => pair[0], :value => pair[1] } }
          }

          result = self.build_result(api_method, parameters, body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
