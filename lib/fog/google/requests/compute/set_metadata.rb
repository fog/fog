module Fog
  module Compute
    class Google
      class Mock
        def set_metadata(instance, zone, fingerprint, metadata={})
          Fog::Mock.not_implemented
        end
      end

      class Real
        # Set an instance metadata
        #
        # ==== Parameters
        # * instance<~String> - Instance name (identity)
        # * zone<~String> - Zone short name (without the full path)
        # * fingerprint<~String> - The fingerprint of the last metadata. Can be retrieved by reloading the compute object, and checking the metadata fingerprint field.
        #     instance.reload
        #     fingerprint = instance.metadata["fingerprint"]
        # * metadata<~Hash> - A new metadata
        #
        # ==== Returns
        # * response<~Excon::Response>
        def set_metadata(instance, zone_name_or_url, fingerprint, metadata = {})
          api_method = @compute.instances.set_metadata
          zone_name = get_zone_name(zone_name_or_url)
          parameters = {project: @project, zone: zone_name, instance: instance}

          body_object = {
            "fingerprint" => fingerprint,
            "items" => metadata.to_a.map {|pair| { :key => pair[0], :value => pair[1] } }
          }
          request(api_method, parameters, body_object=body_object)
        end
      end
    end
  end
end
