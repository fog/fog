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
          attributes[:description]= NonLoaded if attributes[:description].nil?
        end
        
        def description
          reload if attributes[:description] == NonLoaded and !@inspecting
          attributes[:description]
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