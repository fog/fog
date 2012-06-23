module Fog
  module Rackspace
    class Identity
      class Real
        def create_token(username, api_key)
          data = {
            'auth' => {
              'RAX-KSKEY:apiKeyCredentials' => {
                'username' => username,
                'apiKey' => api_key
              }
            }
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => [200, 203],
            :method => 'POST',
            :path => 'tokens'
          )
        end
      end
    end
  end
end
