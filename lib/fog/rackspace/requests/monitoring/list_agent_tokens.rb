module Fog
  module Rackspace
    class Monitoring
      class Real

        def list_agent_tokens(options={})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'agent_tokens',
            :query    => options
          )
        end

      end
    end
  end
end

