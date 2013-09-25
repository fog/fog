require 'fog/core/model'

module Fog
  module Support
    class StormOnDemand

      class Alert < Fog::Model
        attribute :message
        attribute :subject

        def initialize(attributes={})
          super
        end

      end

    end
  end
end
