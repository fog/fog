require 'fog/core/model'

module Fog
  module Compute
    class StormOnDemand

      class Config < Fog::Model
        identity :id

        attribute :available
        attribute :description
        attribute :disk
        attribute :featured
        attribute :memory
        attribute :price
        attribute :vcpu
      end

      def initialize(attributes={})
        super
      end
      
    end
  end
end
