module Fog
  module Compute
    class DigitalOcean
      class Real

        #
        # FIXME: missing ssh keys support
        #
        def destroy_server( id )
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "droplets/#{id}/destroy"
          )
        end

      end

      class Mock

        def destroy_server( id )
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
