module Fog
  module Compute
    class OpenStack
      class Real

        def get_server_volumes(server_id)

          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/servers/#{server_id}/os-volume_attachments"
          )
        end

      end

      class Mock

      end

    end
  end
end
