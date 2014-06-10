require 'fog/core/model'
require 'fog/rackspace/models/monitoring/base'

module Fog
  module Rackspace
    class Monitoring
      class Metric < Fog::Rackspace::Monitoring::Base
        identity  :name
        attribute :check

        def datapoints(options={})
          @datapoints ||= begin
            Fog::Rackspace::Monitoring::DataPoints.new(
              :metric        => self,
              :service       => service
            )
          end
        end
      end
    end
  end
end
