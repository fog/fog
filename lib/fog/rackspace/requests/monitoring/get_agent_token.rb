module Fog
  module Rackspace
    class Monitoring
      class Real

        def get_agent_token(id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "agent_tokens/#{id}"
          )
        end

      end
    end
  end
end


