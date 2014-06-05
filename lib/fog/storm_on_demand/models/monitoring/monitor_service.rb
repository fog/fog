require 'fog/core/model'

module Fog
  module Monitoring
    class StormOnDemand
      class MonitorService < Fog::Model
        attribute :can_monitor
        attribute :enabled
        attribute :services
        attribute :uniq_id
        attribute :unmonitored

        def initialize(attributes={})
          super
        end
      end
    end
  end
end
