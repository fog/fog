require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class Organization < Fog::Model
        
        identity  :id
                  
        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => 'Description'
        attribute :links, :aliases => 'Links'
      end
    end
  end
end