require 'fog/core/model'

module Fog
  module Compute
    class StormOnDemand

      class PrivateIp < Fog::Model
        attribute :zone
        attribute :uniq_id

        def initialize(attributes={})
          super
        end

      end

    end
  end
end
