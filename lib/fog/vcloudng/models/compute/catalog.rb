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
          lazy_load_attrs = self.class.attributes - attributes.keys
          lazy_load_attrs.each do |attr|
            attributes[attr]= NonLoaded if attributes[attr].nil? 
            make_lazy_load_method(attr)
          end
        end
        
        def make_lazy_load_method(attr)
          self.class.instance_eval do 
            define_method(attr) do
              reload if attributes[attr] == NonLoaded and !@inspecting
              attributes[attr]
            end
          end
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