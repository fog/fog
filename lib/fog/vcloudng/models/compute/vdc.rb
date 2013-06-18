require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class Vdc < Fog::Model
        
        identity  :id
                  
        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => 'Description'
        attribute :available_networks, :aliases => 'AvailableNetworks'
        attribute :compute_capacity , :aliases => 'ComputeCapacity'
        attribute :storage_capacity , :aliases => 'StorageCapacity'
        
      end
    end
  end
end