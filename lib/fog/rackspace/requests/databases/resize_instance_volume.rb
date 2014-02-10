module Fog
  module Rackspace
    class Databases
      class Real
        def resize_instance_volume(instance_id, volume_size)
          data = {
            'resize' => {
              'volume' => {
                'size' => volume_size
              }
            }
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => 202,
            :method => 'POST',
            :path => "instances/#{instance_id}/action"
          )
        end
      end
    end
  end
end
