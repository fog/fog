module Fog
  module Compute
    class Google

      class Mock

        def attach_disk(instance_name, disk_url, zone_name_or_url, options = {})
          Fog::Mock.not_implemented
        end

      end

      class Real

        def attach_disk(instance_name, disk_url, zone_name_or_url, options = {})

          api_method = @compute.instances.attach_disk
          parameters = instance_request_parameters(instance, zone_name_or_url)

          request_body = {
            'type' => 'PERSISTENT',                   # possible values: 'PERSISTENT' and 'SCRATCH' (depricated)
            'mode' => options[:mode] || 'READ_WRITE', # possible values: 'READ_WRITE' and 'READ_ONLY'
            'source' => disk_url,                     # The fully-qualified URL to the Persistent Disk resource.
            'deviceName' => options[:device_name],
            'boot' => options[:boot] || false
          }

          request_body.merge!({'deviceName' => options[:device_name]}) if options[:device_name]

          result = self.build_result(api_method, parameters, request_body)

          response = self.build_response(result)
        end
      end
    end
  end
end
