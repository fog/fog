module Fog
  module Voxel
    class Compute
      class Real
        def voxcloud_status( device_id = nil )
          options = { :verbosity => 'compact' }

          ## TODO remove this
          options[:customer_id] = 1470

          unless device_id.nil?
            options[:device_id] = device_id
          end

          data = request("voxel.voxcloud.status", options)

					if data['stat'] == 'fail'
						[]
					else
						if data['devices']['device'].is_a?(Hash)
							devices = [ data['devices']['device'] ]
						else
							devices = data['devices']['device']
						end

						devices.map { |d| { :id => d['id'], :status => d['status'] } }
					end
				end
      end

      class Mock
        def voxcloud_status( device_id = nil )
					devices = [
            { :id => '12345', :status => "QEUEUED" },
            { :id => '67890', :status => "FAILED" },
            { :id => '54321', :status => "IN_PROGRESS" },
            { :id => '10986', :status => "SUCCEEDED" } ]

					if device_id.nil?
						devices
					else
						devices.select { |d| d[:id] == device_id }
					end
				end
      end
    end
  end
end
