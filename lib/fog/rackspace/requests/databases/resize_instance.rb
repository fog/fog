module Fog
  module Rackspace
    class Databases
      class Real
        def resize_instance(instance_id, flavor_id)
          data = {
            'resize' => {
              'flavorRef' => flavor_id
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
