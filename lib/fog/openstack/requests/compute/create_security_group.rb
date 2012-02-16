module Fog
  module Compute
    class Openstack
      class Real

        def create_security_group(name, description)
          data = {
            'security_group' => {
              'name'       => name,
              'description' => description
            }
          }

          request(
            :body     => MultiJson.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-security-groups.json'
          )
        end

      end

      class Mock



      end

    end
  end
end
