module Fog
  module Volume
    class OpenStack
      class Real
        def create_volume(name, description, size, options={})
          data = {
            'volume' => {
              'display_name'        => name,
              'display_description' => description,
              'size'                => size
            }
          }

          optional_keys = [:snapshot_id, :imageRef, :volume_type, :source_volid, :availability_zone]
          optional_keys.each do |key|
            if options[key]
              request_key = Fog::VolumeOpenStack::Volume.aliases[key]
              data['volume'][request_key] = options[key]
            end
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "volumes"
          )
        end
      end

      class Mock
        def create_volume(name, description, size, options={})
          response = Excon::Response.new
          response.status = 202
          response.body = {
            'volume' => {
              'id'                  => Fog::Mock.random_numbers(2),
              'display_name'        => name,
              'display_description' => description,
              'size'                => size,
              'status'              => 'creating',
              'snapshot_id'         => options[:snapshot_id] || nil,
              'image_id'            => options[:imageRef] || nil,
              'volume_type'         => nil,
              'availability_zone'   => 'nova',
              'created_at'          => Time.now,
              'attachments'         => []
            }
          }
          response
        end
      end
    end
  end
end
