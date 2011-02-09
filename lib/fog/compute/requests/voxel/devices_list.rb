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
            []
          elsif data['devices'].empty?
            []
          else
            devices = data['devices']['device']
            devices = [ devices ] if devices.is_a?(Hash)

            ## TODO find both voxserver and voxcloud devices
            devices.select { |d| d['type']['id'] == '3' }.map do |device|
              { :id               => device['id'],
                :name             => device['label'],
								:addresses				=> {
									:public  => device['ipassignments']['ipassignment'].select { |i| i['type'] == "frontend" }.first['content'],
									:private => device['ipassignments']['ipassignment'].select { |i| i['type'] == "backend" }.first['content'] },
                :processing_cores => device['processor']['cores'].to_i,
                :facility         => device['location']['facility']['code'],
                :disk_size        => device['storage']['drive']['size'].to_i,
								:password					=> device['accessmethods']['accessmethod'].select { |am| am['type'] == 'admin' }.first['password'] }
            end
          end
        end
      end

      class Mock
        def devices_list( device_id = nil)
          devices = [
            { :id => '12345', :name => "device1.test", :processing_cores => 1,  :facility  => 'LDJ1', :disk_size => 10,
							:addresses => { :public => "192.168.1.10", :private => "172.16.0.10" }, :password => 'foo' },
            { :id => '67890', :name => "device2.test", :processing_cores => 5,  :facility  => 'AMS2', :disk_size => 100,
							:addresses => { :public => "192.168.2.10", :private => "172.16.1.10" }, :password => 'bar' },
            { :id => '54321', :name => "device3.test", :processing_cores => 11, :facility  => 'LGA7', :disk_size => 500,
							:addresses => { :public => "192.168.3.10", :private => "172.16.2.10" }, :password => 'blee' },
            { :id => '10986', :name => "device4.test", :processing_cores => 2,  :facility  => 'SIN1', :disk_size => 15,
							:addresses => { :public => "192.168.4.10", :private => "172.16.3.10" }, :password => 'blah' } ]

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
