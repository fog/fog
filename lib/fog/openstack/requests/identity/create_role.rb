module Fog
  module Identity
    class OpenStack
      class Real
        def create_role(name)
          data = {
            'role' => {
              'name' => name
            }
          }

          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path   => '/OS-KSADM/roles'
          )
        end
      end

      class Mock
        def create_role(name)
          response = Excon::Response.new
          response.status = 202
          data = {
            'id'          => Fog::Mock.random_numbers(6).to_s,
            'name'        => name
          }
          self.data[:roles][data['id']] = data
          response.body = { 'role' => data }
          response
        end

      end
    end
  end
end
