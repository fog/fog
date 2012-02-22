module Fog
  module Identity
    class OpenStack
      class Real

        def list_endpoints_for_token(token_id)
          request(
            :expects  => [200, 203],
            :method   => 'HEAD',
            :path     => "tokens/#{token_id}/endpoints"
          )
        end

      end

      class Mock



      end
    end
  end
end
