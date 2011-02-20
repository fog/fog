module Fog
  module Voxel
    class Compute
      class Real
        def devices_list( device_id = nil )
          # name, processing_cores, status, facility
          options = { :verbosity => 'normal' }

          unless device_id.nil?
            options[:device_id] = device_id
          end

          data = request("voxel.devices.list", options)

          if data['stat'] == 'fail'
            raise Fog::Voxel::Compute::NotFound
          elsif data['devices'].empty?
            []
          else
            devices = data['devices']['device']
            devices = [ devices ] if devices.is_a?(Hash)

            ## TODO find both voxserver and voxcloud devices
            devices.select { |d| d['type']['id'] == '3' }.map do |device|
              { :id               => device['id'].to_i,
                :name             => device['label'],
                :image_id         => 0,
                :addresses        => {
                  :public  => device['ipassignments']['ipassignment'].select { |i| i['type'] == "frontend" }.first['content'],
                  :private => device['ipassignments']['ipassignment'].select { |i| i['type'] == "backend" }.first['content'] },
                :processing_cores => device['processor']['cores'].to_i,
                :facility         => device['location']['facility']['code'],
                :disk_size        => device['storage']['drive']['size'].to_i,
                :password         => device['accessmethods']['accessmethod'].select { |am| am['type'] == 'admin' }.first['password'] }
            end
          end
        end
      end

      class Mock
        def devices_list( device_id = nil)
          if device_id.nil?
            @data[:servers]
          else
            result = @data[:servers].select { |d| d[:id] == device_id }

            if result.empty?
              raise Fog::Voxel::Compute::NotFound
            else
              result
            end
          end
        end
      end
    end
  end
end
