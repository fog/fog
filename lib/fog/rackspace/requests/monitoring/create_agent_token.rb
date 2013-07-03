module Fog
  module Rackspace
    class Monitoring
      class Real

        def create_agent_token(options = {})
          data = options.dup
          request(
            :body     => JSON.encode(data),
            :expects  => [201],
            :method   => 'POST',
            :path     => 'agent_tokens'
          )
        end
      end
    end
  end
end

