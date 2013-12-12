require 'fog/core/model'

module Fog
  module Joyent
    class Analytics
      class Metric < Fog::Model
        attribute :name
        attribute :label

      end
    end
  end
end
