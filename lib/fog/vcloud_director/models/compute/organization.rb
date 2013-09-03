require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector

      class Organization < Model
        
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
        
      end
    end
  end
end