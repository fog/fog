require 'fog/core/model'
require 'fog/vcloudng/models/compute/vm_customization'


module Fog
  module Compute
    class Vcloudng

      class Vm < Fog::Model
        
        identity  :id
                  
        attribute :name
        attribute :type
        attribute :href
        attribute :status 
        attribute :operating_system
        attribute :ip_address
        attribute :cpu
        attribute :memory
#        attribute :disks
      
        def customization
          data = service.get_vm_customization(id).body
          puts data
          #VmCustomization.new(data)
          service.vm_customizations.new(data)
        end
        
      end
    end
  end
end