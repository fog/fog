require 'fog/core/collection'
require 'fog/rackspace/models/monitoring/agent_token'

module Fog
  module Rackspace
    class Monitoring
      class AgentTokens < Fog::Collection
        attribute :marker

        model Fog::Rackspace::Monitoring::AgentToken

        def all(options={})
          clear
          body = service.list_agent_tokens(options).body
          self.marker = body['metadata']['next_marker']

          load(body['values'])
        end

        def get(id)
          data = service.get_agent_token(id).body
          new(data)
        rescue Fog::Rackspace::Monitoring::NotFound
          nil
        end
      end
    end
  end
end
