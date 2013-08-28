require 'fog/core/model'

module Fog
  module Rackspace
    class AutoScale
      class LaunchConfig < Fog::Model

        attribute :group
      	attribute :type
      	attribute :args

      	def update
          
          options = {}
          options['type'] = type unless type.nil?
          options['args'] = args unless args.nil?

          data = service.update_launch_config(group.id, options)
          merge_attributes(data.body['launchConfiguration'])
          true
        end

      end
  	end
  end
end