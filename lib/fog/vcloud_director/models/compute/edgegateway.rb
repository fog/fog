require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector

        class Edgegateway < Model
  
          identity  :id
  
          attribute :name
          attribute :type
          attribute :href
          attribute :edgegatewayserviceconfiguration
         #TO DO Add more attrs
        

       end
    end
  end
end
