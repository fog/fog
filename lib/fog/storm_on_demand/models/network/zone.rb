require "fog/core/model"

module Fog
  module Network
    class StormOnDemand

      class Zone < Fog::Model
        identity :id
        attribute :is_default
        attribute :name
        attribute :region
        attribute :status
        attribute :valid_source_hvs

        def initialize(attributes={})
          super
        end

        def set_default
          requires :identity
          service.set_default_zone(:id => identity)
        end

      end
    end
  end
end
