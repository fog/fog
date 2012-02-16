module Fog
  module Compute
    class Openstack
      class Real

        def create_key_pair(key_name, public_key = nil)

          data = {
            'keypair' => {
              'name' => key_name
            }
          }

          data['keypair']['public_key'] = public_key unless public_key.nil?

          request(
            :body     => MultiJson.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-keypairs.json'
          )
        end

      end

      class Mock



      end

    end
  end
end
