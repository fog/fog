require 'fog/core/collection'
require 'fog/vcloudng/models/compute/vm_customization'

module Fog
  module Compute
    class Vcloudng

      class VmCustomizations < Fog::Collection
        model Fog::Compute::Vcloudng::VmCustomization
        
        attribute :vm
        
        
      end
    end
  end
end