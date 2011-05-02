require 'fog/core/model'

module Fog
  module StormOnDemand
    class Compute

      class Template < Fog::Model
        identity :id
        attribute :name
        attribute :description
        attribute :manage_level
        attribute :os
        attribute :price
      end

      def initialize(attributes={})
        super
      end

    end
  end
end
