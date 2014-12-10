module Fog
  module Rackspace
    class Databases
      class Real
        def create_instance(name, flavor_id, volume_size, options = {})
          data = {
            'instance' => {
              'name' => name,
              'flavorRef' => flavor_id,
              'volume' => {
                'size' => volume_size
              },
              'databases' => [
              ]
            }
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => 200,
            :method => 'POST',
            :path => 'instances'
          )
        end
      end
    end
  end
end
