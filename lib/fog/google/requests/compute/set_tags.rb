module Fog
  module Compute
    class Google
      class Mock
        def set_tags(instance, zone, tags=[])
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_tags(instance, zone_name_or_url, fingerprint, tags=[])
          api_method = @compute.instances.set_tags
          parameters = instance_request_parameters(instance, zone_name_or_url)
          body_object = { "fingerprint" => fingerprint, "items" => tags }
          request(api_method, parameters, body_object=body_object)
        end
      end
    end
  end
end
