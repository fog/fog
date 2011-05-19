require 'fog/core/model'

module Fog
  module AWS
    class CloudWatch

      class MetricStatistic < Fog::Model
        attribute :label, :aliases => 'Label'
        attribute :minimum, :aliases => 'Minimum'
        attribute :maximum, :aliases => 'Maximum'
        attribute :sum, :aliases => 'Sum'
        attribute :average, :aliases => 'Average'
        attribute :sample_count, :aliases => 'SampleCount'
        attribute :timestamp, :aliases => 'Timestamp'
        attribute :unit, :aliases => 'Unit'
      end
    end
  end
end