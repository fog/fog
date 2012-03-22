require 'fog/core/model'

module Fog
  module Compute
    class IBM
      class Location < Fog::Model
        identity :id
        attribute :name
        attribute :location
        attribute :capabilities
        attribute :description
      end
    end
  end
end
