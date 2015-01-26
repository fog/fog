require 'fog/core/model'

module Fog
  module Compute
    class Google
      class Zone < Fog::Model
        identity :name
        attribute :description
        attribute :status
        attribute :maintenance_windows, :aliases => 'maintenanceWindows'
        attribute :begin_time, :aliases => 'beginTime'
        attribute :end_time, :aliases => 'endTime'
        attribute :quotas
        attribute :region
        attribute :self_link, :aliases => 'selfLink'

        def up?
          self.status == "UP"
        end
      end
    end
  end
end
