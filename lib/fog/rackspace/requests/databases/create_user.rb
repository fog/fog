module Fog
  module Rackspace
    class Databases
      class Real
        def create_user(instance_id, name, password, options = {})
          data = {
            'users' => [{
              'name' => name,
              'password' => password,
              'databases' => options[:databases] || [],
              'host' => options[:host] || '%'
            }]
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => 202,
            :method => 'POST',
            :path => "instances/#{instance_id}/users"
          )
        end
      end
    end
  end
end
