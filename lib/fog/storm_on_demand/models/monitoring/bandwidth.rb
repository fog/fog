require 'fog/core/model'

module Fog
  module Monitoring
    class StormOnDemand
      class Bandwidth < Fog::Model
        attribute :actual
        attribute :averages
        attribute :cost
        attribute :domain
        attribute :pricing
        attribute :projected

        def initialize(attributes={})
          super
        end
      end
    end
  end
end
