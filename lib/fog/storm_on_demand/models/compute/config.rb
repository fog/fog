require 'fog/core/model'

module Fog
  module Compute
    class StormOnDemand

      class Config < Fog::Model
        identity :id

        attribute :active
        attribute :available
        attribute :category
        attribute :description
        attribute :disk, :aliases => ['disk_total']
        attribute :memory, :aliases => ['ram_available']
        attribute :vcpu, :aliases => ['cpu_cores']
      end

      def initialize(attributes={})
        super
      end
      
    end
  end
end
