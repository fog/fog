require 'fog/core/collection'
require 'fog/storm_on_demand/models/support/alert'

module Fog
  module Support
    class StormOnDemand
      class Alerts < Fog::Collection
        model Fog::Support::StormOnDemand::Alert

        def get_active
          alert = service.get_active_alert.body['active_alert']
          new(alert)
        end
      end
    end
  end
end
