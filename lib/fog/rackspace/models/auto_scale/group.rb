require 'fog/core/model'
require 'fog/rackspace/models/auto_scale/group_config'
require 'fog/rackspace/models/auto_scale/launch_config'
require 'fog/rackspace/models/auto_scale/policies'

module Fog
  module Rackspace
    class AutoScale
      class Group < Fog::Model
        # @!attribute [r] id
        # @return [String] The autoscale group's id
        identity :id

        # @!attribute [r] links
        # @return [Array] group links.
        attribute :links

        # Gets the group configuration for this autoscale group. The configuration describes the
        # minimum number of entities in the group, the maximum number of entities in the group,
        # the global cooldown time for the group, and other metadata.
        #
        # @return [Fog::Rackspace::AutoScale::GroupConfiguration] group_config if found
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/GET_getGroupConfig_v1.0__tenantId__groups__groupId__config_Configurations.html
        def group_config
          if attributes[:group_config].nil? && persisted?
            data = service.get_group_config(identity)
            attributes[:group_config] = load_model('GroupConfig', data.body['groupConfiguration'])
          end
          attributes[:group_config]
        end

        # Sets the configuration when this object is populated.
        #
        # @param object [Hash<String, String>] Object which will stock the object
        def group_config=(object = {})
          if object.is_a?(Hash)
            attributes[:group_config] = load_model('GroupConfig', object)
          else
            attributes[:group_config] = object
          end
        end

        # Gets the launch configuration for this autoscale group. The launch configuration describes
        # the details of how to create a server, from what image to create a server, which load balancers
        # to join the server to, which networks to add the server to, and other metadata.
        #
        # @return [Fog::Rackspace::AutoScale::LaunchConfiguration] group_config if found
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/GET_getLaunchConfig_v1.0__tenantId__groups__groupId__launch_Configurations.html
        def launch_config
          if attributes[:launch_config].nil?  && persisted?
            data = service.get_launch_config(identity)
            attributes[:launch_config] = load_model('LaunchConfig', data.body['launchConfiguration'])
          end
          attributes[:launch_config]
        end

        # Sets the configuration when this object is populated.
        #
        # @param object [Hash<String, String>] Object which will stock the object
        def launch_config=(object={})
          if object.is_a?(Hash)
            attributes[:launch_config] = load_model('LaunchConfig', object)
          else
            attributes[:launch_config] = object
          end
        end

        # For the specified autoscaling group, this operation returns a list of the scaling policies
        # that are available to the group. Each policy is described in terms of an ID, name, type,
        # adjustment, cooldown time, and links.
        #
        # @return [Fog::Rackspace::AutoScale::Policies] policies
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/GET_getPolicies_v1.0__tenantId__groups__groupId__policies_Policies.html
        def policies
          return @policies if @policies
          if persisted?
            @policies = load_model('Policies')
          else
            @policies = Fog::Rackspace::AutoScale::Policies.new(:service => service, :group => self)
            @policies.clear
          end
          @policies
          # return nil unless persisted?
          # @policies ||= load_model('Policies')
        end

        # Creates group
        # * requires attributes: :launch_config, :group_config, :policies
        #
        # @return [Boolean] returns true if group is being created
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see Groups#create
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/POST_createGroup_v1.0__tenantId__groups_Groups.html
        def save
          requires :launch_config, :group_config, :policies
          raise Fog::Errors::Error.new("You should update launch_config and group_config directly") if persisted?

          launch_config_hash = {
            'args' => launch_config.args,
            'type' => launch_config.type
          }
          group_config_hash = {
            'name' => group_config.name,
            'cooldown' => group_config.cooldown,
            'maxEntities' => group_config.max_entities,
            'minEntities' => group_config.min_entities
          }
          group_config_hash['metadata'] = group_config.metadata if group_config.metadata

          data = service.create_group(launch_config_hash, group_config_hash, policies)
          merge_attributes(data.body['group'])
          true
        end

        # Destroy the group
        #
        # @return [Boolean] returns true if group has started deleting
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/DELETE_deleteGroup_v1.0__tenantId__groups__groupId__Groups.html
        def destroy
          requires :identity
          service.delete_group(identity)
          true
        end

        # Get the current state of the autoscale group
        #
        # @return [String] the state of the group
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/GET_getGroupState_v1.0__tenantId__groups__groupId__state_Groups.html
        def state
          requires :identity
          data = service.get_group_state(identity)
          data.body['group']
        end

        # This operation pauses all execution of autoscaling policies.
        #
        # @note NOT IMPLEMENTED YET
        # @return [Boolean] returns true if paused
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/POST_pauseGroup_v1.0__tenantId__groups__groupId__pause_Groups.html
        def pause
          requires :identity
          data = service.pause_group_state(identity)
          true
        end

        # This operation resumes all execution of autoscaling policies.
        #
        # @note NOT IMPLEMENTED YET
        # @return [Boolean] returns true if resumed
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/POST_resumeGroup_v1.0__tenantId__groups__groupId__resume_Groups.html
        def resume
          requires :identity
          data = service.resume_group_state(identity)
          true
        end

        private

        def load_model(class_name, attrs = nil)
          model = Fog::Rackspace::AutoScale.const_get(class_name).new({
            :service => @service,
            :group   => self
          })
          if service && attrs
            model.merge_attributes(attrs)
          end
          model
        end
      end
    end
  end
end
