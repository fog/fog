module Fog
  module Volume
    class OpenStack
      module Real
        private
        def _create_volume_snapshot(data)
          data = {
              'snapshot' => {
                  'volume_id'           => volume_id,
                  'display_name'        => name,
                  'display_description' => description,
                  'force'               => force
              }
          }

          request(
              :body    => Fog::JSON.encode(data),
              :expects => [200, 202],
              :method  => 'POST',
              :path    => "snapshots"
          )
        end
      end
    end
  end
end
