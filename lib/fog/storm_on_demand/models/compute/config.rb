require 'fog/core/model'

module Fog
  module Compute
    class StormOnDemand
      class Config < Fog::Model
        identity :id

        attribute :active
        attribute :available
        attribute :category
        attribute :cpu_cores
        attribute :cpu_count
        attribute :cpu_hyperthreading
        attribute :cpu_model
        attribute :cpu_speed
        attribute :description
        attribute :disk
        attribute :disk_count
        attribute :disk_total
        attribute :disk_type
        attribute :featured
        attribute :memory
        attribute :raid_level
        attribute :ram_available
        attribute :ram_total
        attribute :price
        attribute :vcpu
        attribute :zone_availability

        def initialize(attributes={})
          super
        end
      end
    end
  end
end
