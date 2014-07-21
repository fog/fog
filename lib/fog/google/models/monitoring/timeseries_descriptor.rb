require 'fog/core/model'

module Fog
  module Google
    class Monitoring
      ##
      # A time series is a collection of data points that represents the value of a metric of a project over time.
      # The metric is described by the time-series descriptor. Each time-series descriptor is uniquely identified by
      # its metric name and a set of labels.
      #
      # @see https://developers.google.com/cloud-monitoring/v2beta1/timeseriesDescriptors
      class TimeseriesDescriptor < Fog::Model
        identity :metric

        attribute :labels
        attribute :project
      end
    end
  end
end
