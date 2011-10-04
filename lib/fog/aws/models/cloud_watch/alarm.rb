require 'fog/core/model'

module Fog
  module AWS
    class CloudWatch

      class Alarm < Fog::Model
        attribute :alarm_names, :aliases => 'AlarmNames'
      end
    end
  end
end
