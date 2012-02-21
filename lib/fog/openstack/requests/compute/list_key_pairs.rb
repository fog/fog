module Fog
  module Compute
    class OpenStack
      class Real

        def list_key_pairs
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'os-keypairs.json'
          )
        end

      end

      class Mock



      end
    end
  end
end
