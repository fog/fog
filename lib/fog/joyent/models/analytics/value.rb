require 'fog/core/model'

module Fog
  module Joyent
    class Analytics
      class Value < Fog::Model
        attribute :value
        attribute :transformations
        attribute :start_time, :type => :timestamp
        attribute :duration
        attribute :end_time, :type => :timestamp
        attribute :nsources
        attribute :minreporting
        attribute :requested_start_time, :type => :timestamp
        attribute :requested_duration
        attribute :requested_end_time, :type => :timestamp
      end
    end
  end
end
