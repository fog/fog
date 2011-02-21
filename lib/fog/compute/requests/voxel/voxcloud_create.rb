module Fog
  module Voxel
    class Compute
      class Real
        def voxcloud_create( options )
          options[:hostname] = options[:name]
          options.delete(:name)

          if options.has_key?(:password)
            options[:admin_password] = options[:password]
            options.delete(:password)
          end

          data = request("voxel.voxcloud.create", options)

          unless data['stat'] == 'ok'
            raise "Error from Voxel hAPI: #{data['err']['msg']}"
          end

          devices_list(data['device']['id'])
        end
      end

      class Mock
        def voxcloud_create( options )
          device_id = Fog::Mock.random_numbers(7).to_i
          @data[:last_modified][:servers][device_id] = Time.now
          @data[:last_modified][:statuses][device_id] = Time.now
          @data[:statuses][device_id] = "QUEUED"
          @data[:servers].push( options.merge( {
            :password => "CHANGEME",
            :id => device_id,
            :addresses => { :private => '0.0.0.0', :public => '0.0.0.0' }
          } ) )
          devices_list(device_id)
        end
      end
    end
  end
end
