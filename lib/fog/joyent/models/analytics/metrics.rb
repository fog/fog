require 'fog/joyent/models/analytics/metric'

module Fog
  module Joyent
    class Analytics
      class Metrics < Fog::Collection
        model Fog::Joyent::Analytics::Metric

        def all
          data = service.describe_analytics.body['metrics']
          load(data)
        end
      end
    end
  end
end
