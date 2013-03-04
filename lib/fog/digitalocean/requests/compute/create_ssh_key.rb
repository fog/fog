module Fog
  module Compute
    class DigitalOcean
      class Real

        def create_ssh_key( name, pub_key )
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'droplets/new',
            :query    => { 'name' => name, 'ssh_pub_key' => pub_key }
          )
        end

      end

      class Mock

        def create_ssh_key( name, pub_key )
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
