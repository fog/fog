require 'fog/core/collection'
require 'fog/vcloudng/models/compute/vm_network'

module Fog
  module Compute
    class Vcloudng

      class VmNetworks < Fog::Collection
        model Fog::Compute::Vcloudng::VmNetwork
        
        attribute :vm
        
        
      end
    end
  end
end