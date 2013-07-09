require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class Organization < Fog::Model
        
        identity  :id
                  
        attribute :name, :aliases => :FullName
        attribute :type
        attribute :href
        attribute :description, :aliases => :Description
        
        def vdcs
          requires :id
          service.vdcs(:organization => self)
        end
        
        def catalogs
          requires :id
          service.catalogs(:organization => self)
        end
        
        def networks
          requires :id
          service.networks(:organization => self)
        end
        
        def initialize(attrs={})
          super(attrs)
          lazy_load_attrs = self.class.attributes - attributes.keys
          lazy_load_attrs.each do |attr|
            puts "-#{attr}-"
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