require 'fog/core/model'

module Fog
  module Joyent
    class Analytics
      class Field < Fog::Model
        attribute :name
        attribute :label
        attribute :type
      end
    end
  end
end
