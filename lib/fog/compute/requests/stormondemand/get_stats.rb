module Fog
  module Stormondemand
    class Compute
      class Real

        def get_stats(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/monitoring/load/stats",
            :headers  => {"Content-Type" => "application/json"},
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end