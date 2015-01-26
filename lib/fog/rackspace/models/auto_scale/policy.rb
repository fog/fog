require 'fog/core/model'
require 'fog/rackspace/models/auto_scale/webhooks'

module Fog
  module Rackspace
    class AutoScale
      class Policy < Fog::Model
        # @!attribute [r] id
        # @return [String] The policy id
        identity :id

        # @!attribute [r] group
        # @return [Group] The autoscale group
        attribute :group

        # @!attribute [r] links
        # @return [Array] Policy links
        attribute :links

        # @!attribute [r] name
        # @return [String] The policy's name
        attribute :name

        # @!attribute [r] change
        # @return [Fixnum] The fixed change to the autoscale group's number of units
        attribute :change

        # @!attribute [r] changePercent
        # @return [Fixnum] The percentage change to the autoscale group's number of units
        attribute :change_percent, :aliases => 'changePercent'

        # @!attribute [r] cooldown
        # @return [Fixnum] The policy's cooldown
        attribute :cooldown

        # @!attribute [r] type
        # @note Can only be "webhook", "schedule" or "cloud_monitoring"
        # @return [String] The policy's type
        attribute :type

        # @!attribute [r] args
        # @example See below:
        # - "cron": "23 * * * *"
        # - "at": "2013-06-05T03:12Z"
        # - "check": {
        #         "label": "Website check 1",
        #         "type": "remote.http",
        #         "details": {
        #             "url": "http://www.example.com",
        #             "method": "GET"
        #         },
        #         "monitoring_zones_poll": [
        #             "mzA"
        #         ],
        #         "timeout": 30,
        #         "period": 100,
        #         "target_alias": "default"
        #     },
        #     "alarm_criteria": {
        #          "criteria": "if (metric[\"duration\"] >= 2) { return new AlarmStatus(OK); } return new AlarmStatus(CRITICAL);"
        #     }
        #
        # @return [String] Arguments used for the policy
        attribute :args

        # @!attribute [r] desiredCapacity
        # @return [Fixnum] The desired capacity of the group
        attribute :desired_capacity, :aliases => 'desiredCapacity'

        # Basic sanity check to make sure attributes are valid
        #
        # @raise ArgumentError If no type is set
        # @raise ArgumentError If args attribute is missing required keys (if type == 'schedule')

        # @return [Boolean] Returns true if the check passes
        def check_attributes
          raise ArgumentError, "This #{self.name} resource requires the #{type} argument" if type.nil?

          if type == 'schedule'
            raise ArgumentError, "This #{self.name} resource requires the args[cron] OR args[at] argument" if args['cron'].nil? && args['at'].nil?
          end

          true
        end

        def group=(group)
          attributes[:group] = group.is_a?(Group) ? group : service.groups.new(:id => group)
        end

        # Creates policy
        # * requires attributes: :name, :type, :cooldown
        #
        # @return [Boolean] returns true if policy is being created
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see Policies#create
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/POST_createPolicies_v1.0__tenantId__groups__groupId__policies_Policies.html
        def create
          requires :name, :type, :cooldown

          check_attributes

          options = {}
          options['name'] = name unless name.nil?
          options['change'] = change unless change.nil?
          options['changePercent'] = change_percent unless change_percent.nil?
          options['cooldown'] = cooldown unless cooldown.nil?
          options['type'] = type unless type.nil?
          options['desiredCapacity'] = desired_capacity unless desired_capacity.nil?

          if type == 'schedule'
            options['args'] = args
          end

          data = service.create_policy(group.id, options)
          merge_attributes(data.body['policies'][0])
          true
        end

        # Updates the policy
        #
        # @return [Boolean] returns true if policy has started updating
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/PUT_putPolicy_v1.0__tenantId__groups__groupId__policies__policyId__Policies.html
        def update
          requires :identity

          check_attributes

          options = {}
          options['name'] = name unless name.nil?
          options['change'] = change unless change.nil?
          options['changePercent'] = change_percent unless change_percent.nil?
          options['cooldown'] = cooldown unless cooldown.nil?
          options['type'] = type unless type.nil?
          options['desiredCapacity'] = desired_capacity unless desired_capacity.nil?

          if type == 'schedule'
            options['args'] = args
          end

          data = service.update_policy(group.id, identity, options)
          merge_attributes(data.body)
          true
        end

        # Saves the policy
        # Creates policy if it is new, otherwise it will update it
        # @return [Boolean] true if policy has saved
        def save
          if persisted?
            update
          else
            create
          end
          true
        end

        # Destroy the policy
        #
        # @return [Boolean] returns true if policy has started deleting
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/DELETE_deletePolicy_v1.0__tenantId__groups__groupId__policies__policyId__Policies.html
        def destroy
          requires :identity
          service.delete_policy(group.id, identity)
          true
        end

        # Executes the scaling policy
        #
        # @return [Boolean] returns true if policy has been executed
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/POST_executePolicy_v1.0__tenantId__groups__groupId__policies__policyId__execute_Policies.html
        def execute
          requires :identity
          service.execute_policy(group.id, identity)
          true
        end

        # Gets the associated webhooks for this policy
        #
        # @return [Fog::Rackspace::AutoScale::Webhooks] returns Webhooks
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        def webhooks
          requires :identity

          @webhooks ||= Fog::Rackspace::AutoScale::Webhooks.new({
            :service   => service,
            :policy => self,
            :group  => group
          })
        end
      end
    end
  end
end
