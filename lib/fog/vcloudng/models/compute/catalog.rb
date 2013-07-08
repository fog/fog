require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class Catalog < Fog::Model
        
        identity  :id
                  
        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => :Description
        attribute :is_published, :aliases => :IsPublished, :type => :boolean
        
        def catalog_items
          requires :id
          service.catalog_items(:catalog => self)
        end
        
        def initialize(attrs={})
          super(attrs)
          [:description, :is_published].each { |attr| attributes[attr]= NonLoaded if attributes[attr].nil? }
        end
        
        def description
          reload if attributes[:description] == NonLoaded and !@inspecting
          attributes[:description]
        end
        
        def is_published
          reload if attributes[:is_published] == NonLoaded and !@inspecting
          attributes[:is_published]
        end
        
        def inspect
          @inspecting = true
          out = super
          @inspecting = false
          out
        end
        
      end
    end
  end
end