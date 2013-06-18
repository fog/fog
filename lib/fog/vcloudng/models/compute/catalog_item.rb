require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class CatalogItem < Fog::Model
        
        identity  :id
                  
        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => 'Description'
        attribute :vapp_template_id
        
      end
    end
  end
end