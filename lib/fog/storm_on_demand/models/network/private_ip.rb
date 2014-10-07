require 'fog/core/model'

module Fog
  module Network
    class StormOnDemand
      class PrivateIp < Fog::Model
        attribute :zones

        def initialize(attributes={})
          super
        end
      end
    end
  end
end
