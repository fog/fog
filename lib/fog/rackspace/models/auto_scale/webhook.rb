require 'fog/core/model'

module Fog
  module Rackspace
    class AutoScale
      class Webhook < Fog::Model

      	# @!attribute [r] id
        # @return [String] The webhook id   
        identity :id

        # @!attribute [r] id
        # @return [String] The group id (i.e. grand-parent)
        attribute :group_id
        
        # @!attribute [r] id
        # @return [String] The policy id (i.e. parent)
        attribute :policy_id

      	# @!attribute [r] name
        # @return [String] The webhook name
        attribute :name
      	
        # @!attribute [r] metadata
        # @return [Hash] The metadata
        attribute :metadata
      	
        # @!attribute [r] links
        # @return [Array] The webhook links
        attribute :links

        # Creates webhook
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
        def save
          requires :name

          options = {}
          options['name'] = name if name
          options['metadata'] = metadata if metadata

          data = service.create_webhook(group_id, policy_id, options)
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

      		data = service.update_webhook(group_id, policy_id, identity, options)
      		merge_attributes(data.body)
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
      		service.delete_webhook(group_id, policy_id, identity)
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