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

          if data['devices']['device'].is_a?(Hash)
            devices = [ data['devices']['device'] ]
          else
            devices = data['devices']['device']
          end

          devices.map { |d| { :id => d['id'], :status => d['status'] } }
        end
      end

      class Mock
        def voxcloud_status( device_id = nil )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
