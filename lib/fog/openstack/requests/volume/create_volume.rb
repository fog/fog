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

          vanilla_options = ['snapshot_id']
          vanilla_options.select{|o| options[o]}.each do |key|
            data['volume'][key] = options[key]
          end
          request(
            :body     => MultiJson.encode(data),
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
              'id'                 => Fog::Mock.random_numbers(2),
              'displayName'        => name,
              'displayDescription' => description,
              'size'               => size,
              'status'             => 'creating',
              'snapshotId'         => '4',
              'volumeType'         => nil,
              'availabilityZone'   => 'nova',
              'createdAt'          => Time.now,
              'attchments'         => []
            }
          }
          response
        end
      end

    end
  end
end
