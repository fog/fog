module Fog
  module Volume
    class OpenStack

      class Real
        def create_backup(volume_id, options = {})
          data = {
            'backup' => {
              'volume_id' => volume_id,
            }
          }

          vanilla_options = [:container, :name, :description]
          vanilla_options.reject{ |o| options[o].nil? }.each do |key|
            data['backup'][key] = options[key]
          end
          
          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => 'backups'
          )
        end
      end

      class Mock
        def create_backup(volume_id, options = {})
          response = Excon::Response.new
          response.status = 202
          data = {
            'id'                 => Fog::Mock.random_numbers(6).to_s,
            'name'              => options[:name],
            'description'       => options[:description],
            'status'            => 'available',
            'size'              => 1,
            'container'         => options[:container],
            'volume_id'         => volume_id,
            'object_count'      => nil,
            'availability_zone' => nil,
            'created_at'        => Time.now.to_s,
            'fail_reason'       => nil,
            'links'             => [],
          }
          self.data[:backups][data['id']] = data
          response.body = { 'backup' => data }
          response
        end
      end

    end
  end
end