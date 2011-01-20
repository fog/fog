module Fog
  module Voxel
    class Compute
      class Real
        def devices_list( device_id = nil )
          # name, processing_cores, status, facility

          options = { :verbosity => 'normal' }

          ## TODO remove this
          options[:customer_id] = 1470

          unless device_id.nil?
            options[:device_id] = device_id
          end
            
          data = request("voxel.devices.list", options)
         
          if data['devices']['device'].is_a?(Hash)
            devices = [ data['devices']['device'] ]
          else
            devices = data['devices']['device']
          end

          ## TODO find both voxserver and voxcloud devices
          devices.select { |d| d['type']['id'] == '3' }.map do |device|
            { :id               => device['id'],
              :name             => device['label'],
              :processing_cores => device['processor']['cores'],
              :facility         => device['location']['facility']['code'] }
          end
        end
      end

      class Mock
        def images_list
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
