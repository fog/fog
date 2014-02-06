module Fog
  module Compute
    class Google

      class Mock

        def set_metadata(instance, zone_name_or_url, metadata = {})
          Fog::Mock.not_implemented
        end

      end

      class Real

        def set_metadata(instance, zone_name_or_url, fingerprint, metadata = {})
          api_method = @compute.instances.set_metadata
          zone_name = get_zone_name(zone_name_or_url)
          parameters = {project: @project, zone: zone_name, instance: instance}

          body_object = {
            'fingerprint' => fingerprint,
            'items' => metadata.to_a.map { |pair| { :key => pair[0], :value => pair[1] } }
          }
          
          result = self.build_result(api_method, parameters, body_object)

          response = self.build_response(result)
        end
      end
    end
  end
end
