module Fog
  module Vcloud
    class Compute
      class Real
        def login
          headers = { 'Authorization' => authorization_header }
          uri = if version == '1.0'
            "#{base_url}/login"
          else
            "#{base_path_url}/sessions"
          end
          unauthenticated_request({
            :expects  => 200,
            :headers  => headers,
            :method   => 'POST',
            :parse    => true,
            :uri      => uri
          })
        end
      end
    end
  end
end
