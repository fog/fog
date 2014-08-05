require 'fog/core/model'

module Fog
  module Rackspace
    class AutoScale
      class LaunchConfig < Fog::Model
        # @!attribute [r] group
        # @return [Fog::Rackspace::AutoScale::Group] The parent group
        attribute :group

        # @!attribute [r] type
        # @return [Fog::Rackspace::AutoScale::Group] The type of operation (usually "launch_server")
        attribute :type

        # @!attribute [r] args
        # @return [Fog::Rackspace::AutoScale::Group] The arguments for the operation
        attribute :args

        # Update this group's launch configuration
        #
        # @return [Boolean] returns true if launch config has been updated
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/PUT_putLaunchConfig_v1.0__tenantId__groups__groupId__launch_Configurations.html
        def update
          options = {}
          options['type'] = type unless type.nil?
          options['args'] = args unless args.nil?

          service.update_launch_config(group.id, options)
          true
        end

        # Saves group launch configuration.
        # This method will only save existing group configurations. New group configurations are created when a scaling group is created
        #
        # @return [Boolean] true if launch group was saved
        def save
          if group.id
            update
            true
          else
            raise "New #{self.class} are created when a new Fog::Rackspace::AutoScale::Group is created"
          end
        end

        # Reloads group launch configuration
        def reload
          if group.id
            data = service.get_launch_config(group.id)
            merge_attributes data.body['launchConfiguration']
          end
        end
      end
  	end
  end
end
