require 'fog/core/model'

module Fog
  module Rackspace
    class AutoScale
      class GroupConfig < Fog::AutoScale::Rackspace::Config

      	identity :id

      	attribute :name
      	attribute :cooldown
      	attribute :min_entities
      	attribute :max_entities
      	attribute :metadata

      	def update
          requires :identity
          options = {
            'name' => name,
            'cooldown' => cooldown,
            'min_entities' => min_entities,
            'max_entities' => max_entities,
            'metadata' => metadata
          }

          data = service.update_group_config(identity, options)
          merge_attributes(data.body)
          true
        end

      end
  	end
  end
end