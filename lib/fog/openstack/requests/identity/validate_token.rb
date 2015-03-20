module Fog
  module Identity
    class OpenStack
      class Real
        def validate_token(token_id, tenant_id=nil)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "tokens/#{token_id}"+(tenant_id ? "?belongsTo=#{tenant_id}" : '')
          )
        end
      end

      class Mock
      end
    end
  end
end
