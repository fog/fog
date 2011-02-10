module Fog
  module Brightbox
    class Compute
      class Real

        def get_account(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/1.0/account",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end