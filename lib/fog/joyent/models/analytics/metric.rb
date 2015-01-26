require 'fog/core/model'

module Fog
  module Joyent
    class Analytics
      class Metric < Fog::Model
        attribute :module
        attribute :stat
        attribute :label
        attribute :interval
        attribute :fields
        attribute :unit
        attribute :type
      end
    end
  end
end
