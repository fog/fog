require 'fog/core/model'

module Fog
  module Storage
    class StormOnDemand
      class Cluster < Fog::Model
        identity :id
        attribute :description
        attribute :zone

        def initialize(attributes={})
          super
        end
      end
    end
  end
end
