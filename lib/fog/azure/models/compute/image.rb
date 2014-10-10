require 'fog/core/model'

module Fog
  module Compute
    class Azure

      class Image < Fog::Model
        
        identity :name
        attribute :os_type
        attribute :category
        attribute :locations
       
      end
    end
  end
end
