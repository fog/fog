require 'fog/core/model'

module Fog
  module Rackspace
    class AutoScale
      class Webhook < Fog::Model

      	identity :id

        attribute :group_id
        attribute :policy_id

      	attribute :name
      	attribute :metadata
      	attribute :links

        def save
          requires :name

          options = {}
          options['name'] = name unless name.nil?
          options['metadata'] = metadata unless metadata.nil?

          data = service.create_webhook(group_id, policy_id, options)
          true
        end

      	def update
      		requires :identity

      		options = {
      			'name' => name,
      			'metadata' => metadata
      		}

      		data = service.update_webhook(group_id, policy_id, identity, options)
      		merge_attributes(data.body)
      	end

      	def destroy
      		requires :identity 
      		service.delete_webhook(group_id, policy_id, identity)
          true
      	end

        def execution_url
          requires :links
          link = links.select { |l| l['rel'] == 'capability' } 
          link[0]['href']
        end

      end
  	end
  end
end