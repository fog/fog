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
          [:description].each do |attr|
            attributes[attr]='<non_set>' if attributes[attr].nil?
          end
        end
        
        def description
          reload if ( attributes[:description] == '<non_set>' and @inspecting == false )
          attributes[:description]
        end
        
        def inspect
          puts 'inspecting'
          @inspecting = true
          out = super
          @inspecting = false
          out
        end
        
      end
    end
  end
end