module Fog
  module Volume
    class OpenStack

      class Real
        def create_volume(display_name, display_description, size, options = {})
          data = {
            'volume' => {
              'display_name'        => display_name,
              'display_description' => display_description,
              'size'                => size
            }
          }

          vanilla_options = [:volume_type, :snapshot_id, :availability_zone, :metadata, :source_volid]
          vanilla_options.reject{ |o| options[o].nil? }.each do |key|
            data['volume'][key] = options[key]
          end

          request(
            :body    => MultiJson.encode(data),
            :expects => [200, 202],
            :method  => 'POST',
            :path    => 'volumes'
          )
        end
      end

      class Mock
        def create_volume(display_name, display_description, size, options = {})
          response = Excon::Response.new
          response.status = 202
          data = {
            'id'                  => Fog::Mock.random_numbers(6).to_s,
            'display_name'        => display_name,
            'display_description' => display_description,
            'status'              => 'available',
            'size'                => size,
            'volume_type'         => options[:volume_type],
            'snapshot_id'         => options[:snapshot_id],
            'availability_zone'   => options[:availability_zone],
            'created_at'          => Time.now.to_s,
            'attachments'         => [],
            'metadata'            => options[:metadata],
            'source_volid'        => options[:source_volid],
            'bootable'            => 'False',
            'host'                => 'openstack-cinder-node',
            'tenant_id'           => Fog::Mock.random_numbers(6).to_s,
          }
          self.data[:volumes][data['id']] = data
          response.body = { 'volume' => data }
          response
        end
      end

    end
  end
end