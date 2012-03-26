require 'fog/core/model'

module Fog
  module Storage
    class IBM
      class Offering < Fog::Model
        identity :id
        attribute :location
        attribute :name
        attribute :label
        attribute :capacity
        attribute :supported_sizes, :aliases => 'supportedSizes'
        attribute :supported_formats, :aliases => 'formats'
        attribute :price
      end
    end
  end
end
