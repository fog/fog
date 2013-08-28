require 'fog/core/model'

module Fog
  module Rackspace
    class AutoScale
      class GroupConfig < Fog::Model

        attribute :group
      	attribute :name
      	attribute :cooldown
      	attribute :min_entities, :aliases => 'minEntities'
      	attribute :max_entities, :aliases => 'maxEntities'
      	attribute :metadata

      	def update
          
          options = {}

          options['name'] = name unless name.nil?
          options['cooldown'] = cooldown unless cooldown.nil?
          options['minEntities'] = min_entities
          options['maxEntities'] = max_entities
          options['metadata'] = metadata unless metadata.nil?

          data = service.update_group_config(group.id, options)
          merge_attributes(data.body)
          true
        end

      end
  	end
  end
end