require 'fog/core/model'

module Fog
  module Joyent
    class Analytics
      class Type < Fog::Model
        attribute :name
        attribute :arity
        attribute :unit
        attribute :abbr
        attribute :base
        attribute :power
      end
    end
  end
end
