module Fog
  module Compute
    class DigitalOcean
      class Real
        def create_ssh_key( name, pub_key )
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'ssh_keys/new',
            :query    => { 'name' => name, 'ssh_pub_key' => pub_key }
          )
        end
      end

      class Mock
        def create_ssh_key( name, pub_key )
          response = Excon::Response.new
          response.status = 200
          mock_data = {
            "id" => Fog::Mock.random_numbers(1).to_i,
            "name" => name,
            "ssh_pub_key" => pub_key
          }
          response.body = {
            "status" => "OK",
            "ssh_key"  => mock_data
          }
          self.data[:ssh_keys] << mock_data
          response
        end
      end
    end
  end
end
