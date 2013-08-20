require 'fog/core/model'

module Fog
  module Rackspace
    class AutoScale
      class Webhook < Fog::Model

      	identity :id

      	attribute :name
      	attribute :metadata
      	attribute :links

      	def update
      		required :identity

      		options = {
      			'name' => name,
      			'metadata' => metadata
      		}

      		data = service.update_webhook(identity, options)
      		merge_attribute(data.body)
      	end

      	def destroy
      		required :identity
      		service.delete_webhook(identity)
      	end

      end
  	end
  end
end