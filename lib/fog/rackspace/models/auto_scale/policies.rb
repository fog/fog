require 'fog/core/collection'
require 'fog/rackspace/models/auto_scale/policy'

module Fog
  module Rackspace
    class AutoScale
      class Policies < Fog::Collection
        model Fog::Rackspace::AutoScale::Policy

        attr_accessor :group

        # Returns list of autoscale policies
        #
        # @return [Fog::Rackspace::AutoScale::Policies] Retrieves policies
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/GET_getPolicies_v1.0__tenantId__groups__groupId__policies_Policies.html
        def all
          data = service.list_policies(group.id).body['policies']
          load(data)
        end

        # Returns an individual autoscale policy
        #
        # @return [Fog::Rackspace::AutoScale::Group] Retrieves a policy
        # @return nil if not found
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/GET_getPolicy_v1.0__tenantId__groups__groupId__policies__policyId__Policies.html
        def get(policy_id)
          data = service.get_policy(group.id, policy_id).body['policy']
          new(data)
        rescue Fog::Rackspace::AutoScale::NotFound
          nil
        end

        # Create an autoscale policy
        #
        # @return [Fog::Rackspace::AutoScale::Policy] Returns the new policy
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/POST_createPolicies_v1.0__tenantId__groups__groupId__policies_Policies.html
        def create(attributes = {})
          super(attributes)
        end

        def new(attributes = {})
          super({:group => group}.merge(attributes))
        end
      end
    end
  end
end
