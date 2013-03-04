module Fog
  module Compute
    class DigitalOcean 
      class Real

        def list_ssh_keys(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'ssh_keys'
          )
        end

      end

      class Mock

        def list_ssh_keys
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
