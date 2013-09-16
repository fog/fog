require 'fog/core/collection'
require 'fog/rackspace/models/auto_scale/webhook'

module Fog
  module Rackspace
    class AutoScale
      class Webhooks < Fog::Collection

        model Fog::Rackspace::AutoScale::Webhook

        attr_accessor :group_id
        attr_accessor :policy_id

        # Returns list of autoscale webhooks
        #
        # @return [Fog::Rackspace::AutoScale::Policies] Retrieves webhooks
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        def all
          data = service.list_webhooks(group_id, policy_id).body['webhooks']
          load(data)
        end

        # Returns an individual webhook
        #
        # @return [Fog::Rackspace::AutoScale::Webhook] Retrieves a webhook
        # @return nil if not found
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        # 
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/GET_getWebhook_v1.0__tenantId__groups__groupId__policies__policyId__webhooks__webhookId__Webhooks.html
        def get(webhook_id)          
          data = service.get_webhook(group_id, policy_id, webhook_id).body['webhook']
          data['group_id'] = group_id
          data['policy_id'] = policy_id
          new(data)
        rescue Fog::Rackspace::AutoScale::NotFound
          nil
        end

        # Create a webhook
        #
        # @return [Fog::Rackspace::AutoScale::Webhook] Returns the new webhook
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        def create(attributes = {})
          attributes['group_id'] = group_id
          attributes['policy_id'] = policy_id
          super(attributes)
        end

      end
    end
  end
end