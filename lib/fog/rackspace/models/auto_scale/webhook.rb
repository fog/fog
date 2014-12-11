require 'fog/core/model'

module Fog
  module Rackspace
    class AutoScale
      class Webhook < Fog::Model
        # @!attribute [r] id
        # @return [String] The webhook id
        identity :id

        # @!attribute [r] group
        # @return [String] The associated group
        attribute :group

        # @!attribute [r] policy
        # @return [String] The associated policy
        attribute :policy

        # @!attribute [r] name
        # @return [String] The webhook name
        attribute :name

        # @!attribute [r] metadata
        # @return [Hash] The metadata
        attribute :metadata

        # @!attribute [r] links
        # @return [Array] The webhook links
        attribute :links

        # Create webhook
        # * requires attribute: :name
        #
        # @return [Boolean] returns true if webhook is being created
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see Webhooks#create
        # @see
        def create
          requires :name

          options = {}
          options['name'] = name if name
          options['metadata'] = metadata if metadata

          data = service.create_webhook(group.id, policy.id, options)
          merge_attributes(data.body['webhooks'][0])
          true
        end

        # Updates the webhook
        #
        # @return [Boolean] returns true if webhook has started updating
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/PUT_putWebhook_v1.0__tenantId__groups__groupId__policies__policyId__webhooks__webhookId__Webhooks.html
        def update
          requires :identity

          options = {
            'name' => name,
            'metadata' => metadata
          }

          data = service.update_webhook(group.id, policy.id, identity, options)
          merge_attributes(data.body)
          true
        end

        # Saves the webhook
        # Creates hook if it is new, otherwise it will update it
        # @return [Boolean] true if policy has saved
        def save
          if persisted?
            update
          else
            create
          end
          true
        end

        # Destroy the webhook
        #
        # @return [Boolean] returns true if webhook has started deleting
        #
        # @raise [Fog::Rackspace::AutoScale:::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::AutoScale:::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::AutoScale:::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::AutoScale:::ServiceError]
        #
        # @see http://docs.rackspace.com/cas/api/v1.0/autoscale-devguide/content/DELETE_deleteWebhook_v1.0__tenantId__groups__groupId__policies__policyId__webhooks__webhookId__Webhooks.html
        def destroy
          requires :identity
          service.delete_webhook(group.id, policy.id, identity)
          true
        end

        # Retrieves the URL for anonymously executing the policy webhook
        # @return [String] the URL
        def execution_url
          requires :links
          link = links.find { |l| l['rel'] == 'capability' }
          link['href'] rescue nil
        end
      end
    end
  end
end
