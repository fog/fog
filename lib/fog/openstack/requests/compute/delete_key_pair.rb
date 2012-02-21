module Fog
  module Compute
    class OpenStack
      class Real

        def delete_key_pair(key_name)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "os-keypairs/#{key_name}"
          )
        end

      end

      class Mock

      end
    end
  end
end
