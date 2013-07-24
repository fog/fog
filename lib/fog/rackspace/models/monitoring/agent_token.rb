require 'fog/core/model'
require 'fog/rackspace/models/monitoring/base'

module Fog
  module Rackspace
    class Monitoring
      class AgentToken < Fog::Rackspace::Monitoring::Base

        identity :id

        attribute :label
        attribute :token

        def params
          options = {
            'label'                => label,
            'token'                => token
          }
          options.reject {|key, value| value.nil?}
        end

        def save
          if identity
            raise NotImplementedError.new "Updating Agent Tokens is not currently implemented"
          else
            data = service.create_agent_token(params)
          end
          true
        end

      end

    end
  end
end
