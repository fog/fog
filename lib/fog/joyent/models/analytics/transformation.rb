require 'fog/core/model'

module Fog
  module Joyent
    class Analytics
      class Transformation < Fog::Model
        attribute :name
        attribute :label
        attribute :fields
      end
    end
  end
end
