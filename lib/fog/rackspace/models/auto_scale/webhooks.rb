require 'fog/core/collection'
require 'fog/rackspace/models/auto_scale/webhook'

module Fog
  module Rackspace
    class AutoScale
      class Webhooks < Fog::Collection
        model Fog::Rackspace::AutoScale::Webhook

        attr_accessor :group
        attr_accessor :policy

        # Returns list of autoscale webhooks
        #
        # @return [Fog::Rackspace::AutoScale::Policies] Retrieves webhooks
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        def all
          data = service.list_webhooks(group.id, policy.id).body['webhooks']
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
          data = service.get_webhook(group.id, policy.id, webhook_id).body['webhook']
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
          super(attributes)
        end

        def new(attributes = {})
          super({:group => group, :policy => policy}.merge(attributes))
        end
      end
    end
  end
end
