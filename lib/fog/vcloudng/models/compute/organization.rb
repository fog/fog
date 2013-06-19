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
        
      end
    end
  end
end