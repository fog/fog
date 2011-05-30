module Fog
  module Vcloud
    class Compute

      class Real


        def login
          unauthenticated_request({
            :expects  => 200,
            :headers  => {
              'Authorization' => authorization_header
            },
            :method   => 'POST',
            :parse    => true,
            :uri      => "#{base_url}/login"
          })
        end

      end
    end
  end
end
