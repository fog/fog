require 'fog/core/model'
require 'fog/rackspace/models/monitoring/base'

module Fog
  module Rackspace
    class Monitoring
      class DataPoint < Fog::Rackspace::Monitoring::Base
        attribute :num_points, :aliases => "numPoints"
        attribute :average
        attribute :variance
        attribute :min
        attribute :max
        attribute :timestamp
        attribute :metric
      end
    end
  end
end
