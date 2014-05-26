require 'fog/core/model'

# named 'JoyentModule' to avoid name conflicts with ruby's 'Module'
module Fog
  module Joyent
    class Analytics
      class JoyentModule < Fog::Model
        attribute :name
        attribute :label
      end
    end
  end
end
