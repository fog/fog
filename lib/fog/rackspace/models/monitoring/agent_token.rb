require 'fog/core/model'
require 'fog/rackspace/models/monitoring/base'

module Fog
  module Rackspace
    class Monitoring
      class AgentToken < Fog::Rackspace::Monitoring::Base

        identity :id

        attribute :label
        attribute :token

        def prep
          options = {
            'label'                => label,
            'token'                => token
          }
          options = options.reject {|key, value| value.nil?}
          options
        end

        def save
          options = prep
          if identity then
            data = service.update_agent_token(identity, options)
          else
            data = service.create_agent_token(options)
          end
          true
        end

      end

    end
  end
end
