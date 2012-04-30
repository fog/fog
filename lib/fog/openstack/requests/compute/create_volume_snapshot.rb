module Fog
  module Compute
    class OpenStack
      class Real

        def create_volume_snapshot(volume_id, name, description, force=false)
          data = {
            'snapshot' => {
              'volume_id'           => volume_id,
              'display_name'        => name,
              'display_description' => description,
              'force'               => force
            }
          }

          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "os-snapshots"
          )
        end

      end

      class Mock

      end

    end
  end
end
