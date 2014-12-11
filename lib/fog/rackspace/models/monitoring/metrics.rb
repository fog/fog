require 'fog/core/collection'
require 'fog/rackspace/models/monitoring/metric'

module Fog
  module Rackspace
    class Monitoring
      class Metrics < Fog::Collection
        attribute :check

        model Fog::Rackspace::Monitoring::Metric

        def all
          requires :check
          data = service.list_metrics(check.entity.id, check.id).body['values']
          load(data)
        end

        def new(attributes = {})
          requires :check
          super({ :check => check }.merge!(attributes))
        end
      end
    end
  end
end
