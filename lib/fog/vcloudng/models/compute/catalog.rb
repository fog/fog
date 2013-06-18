require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class Catalog < Fog::Model
        
        identity  :id
                  
        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => 'Description'
        attribute :is_published, :aliases => 'IsPublished'
        
        def catalog_items
          requires :id
          service.catalog_items(:catalog => self)
        end
        
      end
    end
  end
end