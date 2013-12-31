module Fog
  module Compute
    class Google

      class Mock
          def attach_disk(instance, zone_name, disk_name, device_name=nil, disk_mode='READ_WRITE', disk_type='PERSISTENT')
            Fog::Mock.not_implemented
        end

      end

      class Real
        
        def attach_disk(instance, zone_name, disk_name, device_name=nil, disk_mode='READ_WRITE', disk_type='PERSISTENT')
          api_method = @compute.instances.attach_disk
          parameters = {
            'project' => @project,
			'instance' => instance,
			'zone' => zone_name
          }
          body_object = {
		    "source"  => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone_name}/disks/#{disk_name}",
			"type"  => disk_type,
            "mode"  => disk_mode,
			"boot"  => false
          }
		  body_object['deviceName'] = device_name if device_name!=nil 
          result = self.build_result(api_method, parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
