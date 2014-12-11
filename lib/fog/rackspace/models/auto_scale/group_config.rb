require 'fog/core/model'

module Fog
  module Rackspace
    class AutoScale
      class GroupConfig < Fog::Model
        # @!attribute [r] group
        # @return [Fog::Rackspace::AutoScale::Group] The parent group
        attribute :group

        # @!attribute [r] name
        # @return [String] The name of the group
      	attribute :name

        # @!attribute [r] cooldown
        # @return [String] The group's cooldown
      	attribute :cooldown

        # @!attribute [r] min_entities
        # @return [Fixnum] The minimum amount of units which should exist in the group
      	attribute :min_entities, :aliases => 'minEntities'

        # @!attribute [r] max_entities
        # @return [Fixnum] The maximum amount of units which should exist in the group
      	attribute :max_entities, :aliases => 'maxEntities'

        # @!attribute [r] metadata
        # @return [Hash] The group's metadata
      	attribute :metadata

        # Update this group's configuration
        #
        # @return [Boolean] returns true if group config has been updated
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/PUT_putGroupConfig_v1.0__tenantId__groups__groupId__config_Configurations.html
        def update
          options = {}
          options['name'] = name unless name.nil?
          options['cooldown'] = cooldown unless cooldown.nil?
          options['minEntities'] = min_entities
          options['maxEntities'] = max_entities
          options['metadata'] = metadata unless metadata.nil?

          service.update_group_config(group.id, options)
          true
        end

        # Saves group configuration.
        # This method will only save existing group configurations. New group configurations are created when a scaling group is created
        #
        # @return [Boolean] true if group config was saved
        def save
          if group.id
            update
            true
          else
            raise "New #{self.class} are created when a new Fog::Rackspace::AutoScale::Group is created"
          end
        end

        # Reloads group configuration
        def reload
          if group.id
            data = service.get_group_config(group.id)
            merge_attributes data.body['groupConfiguration']
          end
        end
      end
  	end
  end
end
