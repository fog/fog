module Fog
  module Volume
    class OpenStack

      class Real
        def create_snapshot(volume_id, display_name, display_description, force = false, options = {})
          data = {
            'snapshot' => {
              'volume_id'           => volume_id,
              'display_name'        => display_name,
              'display_description' => display_description,
              'force'               => force,
            }
          }

          vanilla_options = [:metadata]
          vanilla_options.reject{ |o| options[o].nil? }.each do |key|
            data['snapshot'][key] = options[key]
          end
          
          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => 'snapshots'
          )
        end
        alias_method :create_volume_snapshot, :create_snapshot
      end

      class Mock
        def create_snapshot(volume_id, display_name, display_description, force = false, options = {})
          response = Excon::Response.new
          response.status = 202
          data = {
            'id'                  => Fog::Mock.random_numbers(6).to_s,
            'display_name'        => display_name,
            'display_description' => display_description,
            'status'              => 'available',
            'size'                => 1,
            'volume_id'           => volume_id,
            'created_at'          => Time.now.to_s,
            'metadata'            => options[:metadata] || {},
            'progress'            => '100%',
            'project_id'          => Fog::Mock.random_numbers(6).to_s,
          }
          self.data[:snapshots][data['id']] = data
          response.body = { 'snapshot' => data }
          response
        end
        alias_method :create_volume_snapshot, :create_snapshot
      end

    end
  end
end