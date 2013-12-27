module Fog
  module Compute
    class Google

      class Mock

        def attach_disk(instance_name, zone_name, options = {})
          Fog::Mock.not_implemented
        end

      end

      class Real

        def attach_disk(instance_name, zone_name, options = {})
          if zone_name.start_with? 'http'
            zone_name = zone_name.split('/')[-1]
          end

          api_method = @compute.instances.attach_disk
          parameters = {
            'project' => @project,
            'instance' => instance_name,
            'zone' => zone_name
          }

          request_body = {
            'kind' => 'compute#attachedDisk',
            'index' => options[:index],
            'type' => 'PERSISTENT', # there are 2 possible values: 'PERSISTENT' and 'SCRATCH' (depricated)
            # ! You can only attach a persistent disk in read-write mode to a single instance
            'mode' => options[:mode] || 'READ_WRITE', # possible valuese: READ_WRITE and READ_ONLY
            # The fully-qualified URL to the Persistent Disk resource.
            'source' => URL,
            'deviceName' => options[:device_name],
            'boot' => options[:boot] # ???
          }

          result = self.build_result(api_method, parameters, request_body)
          response = self.build_response(result)
        end

      end

    end
  end
end
