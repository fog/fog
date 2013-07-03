require 'fog/core/collection'
require 'fog/rackspace/models/monitoring/agent_token'

module Fog
  module Rackspace
    class Monitoring
      class AgentTokens < Fog::Collection

        model Fog::Rackspace::Monitoring::AgentToken

        def all
          data = []
          opts = {}
          begin
            new_tokens = service.list_agent_tokens(opts)
            data.concat(new_tokens.body['values'])
            opts = {:marker => new_tokens.body['metadata']['next_marker']}
          end until opts[:marker].nil?

          load(data)
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
