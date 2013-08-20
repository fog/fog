require 'fog/core/model'

module Fog
  module Rackspace
    class AutoScale
      class LaunchConfig < Fog::AutoScale::Rackspace::Config

      	identity :id

      	attribute :type
      	attribute :args

      	def update
          requires :identity
          options = {
            'type' => type,
            'args' => args
          }

          data = service.update_launch_config(identity, options)
          merge_attributes(data.body['launchConfiguration'])
          true
        end

      end
  	end
  end
end